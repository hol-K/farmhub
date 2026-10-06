import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/validators.dart';
import '../models/product.dart';
import 'product_card.dart';

/// Données saisies dans le formulaire de publication (photo déjà compressée).
/// [photo] est null en modification si le producteur garde l'ancienne photo.
class ProductFormData {
  const ProductFormData({
    required this.name,
    required this.variety,
    required this.quantity,
    required this.unit,
    required this.minPrice,
    required this.harvestDate,
    required this.address,
    this.photo,
  });

  final String name;
  final String variety;
  final num quantity;
  final String unit;
  final int minPrice;
  final DateTime harvestDate;
  final String address;
  final XFile? photo;
}

class ProductForm extends StatefulWidget {
  const ProductForm({super.key, required this.onSubmit, this.initial});

  final Future<void> Function(ProductFormData data) onSubmit;

  /// Produit à modifier : préremplit le formulaire, photo facultative.
  final Product? initial;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _imagePicker = ImagePicker();

  String _unit = AppConfig.units.first;
  DateTime? _harvestDate;
  XFile? _photo;
  bool _photoMissing = false;
  bool _isSubmitting = false;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    if (p == null) return;
    _nameController.text = p.name;
    _varietyController.text = p.variety;
    _quantityController.text = '${p.quantity}';
    _priceController.text = '${p.minPrice}';
    _addressController.text = p.address;
    _harvestDate = p.harvestDate;
    _dateController.text = p.harvestDate.dmy;
    if (AppConfig.units.contains(p.unit)) _unit = p.unit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectHarvestDate() async {
    final now = DateTime.now();
    var firstDate = now.subtract(const Duration(days: 30));
    // Produit ancien en modification : sa date doit rester sélectionnable.
    if (_harvestDate != null && _harvestDate!.isBefore(firstDate)) {
      firstDate = _harvestDate!;
    }
    final selected = await showDatePicker(
      context: context,
      initialDate: _harvestDate ?? now,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selected == null) return;
    setState(() {
      _harvestDate = selected;
      _dateController.text = selected.dmy;
    });
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(source: source);
      if (picked == null) return;
      final compressed = await FlutterImageCompress.compressAndGetFile(
        picked.path,
        '${Directory.systemTemp.path}/farmhub_${DateTime.now().millisecondsSinceEpoch}.jpg',
        minWidth: AppConfig.photoMaxSize,
        minHeight: AppConfig.photoMaxSize,
        quality: AppConfig.photoQuality,
        format: CompressFormat.jpeg,
      );
      if (!mounted) return;
      if (compressed == null) {
        _showMessage(AppTexts.photoCompressionError);
        return;
      }
      setState(() {
        _photo = compressed;
        _photoMissing = false;
      });
    } catch (_) {
      if (mounted) _showMessage(AppTexts.photoSelectionError);
    }
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text(AppTexts.takePhoto),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text(AppTexts.chooseFromGallery),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text(AppTexts.cancel),
              onTap: () => Navigator.pop(sheetContext),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _photoMissing = _photo == null && !_editing);
    if (!valid || _photoMissing) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(
        ProductFormData(
          name: _nameController.text.trim(),
          variety: _varietyController.text.trim(),
          quantity: Validators.parseQuantity(_quantityController.text)!,
          unit: _unit,
          minPrice: int.parse(_priceController.text.trim()),
          harvestDate: _harvestDate!,
          address: _addressController.text.trim(),
          photo: _photo,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_photo == null && !_editing)
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _showPhotoOptions,
              icon: const Icon(Icons.add_a_photo_outlined, size: 32),
              label: const Text(AppTexts.addPhoto),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(160),
                side: BorderSide(
                  color: _photoMissing
                      ? theme.colorScheme.error
                      : theme.colorScheme.outlineVariant,
                ),
              ),
            )
          else ...[
            if (_photo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_photo!.path),
                  height: 220,
                  fit: BoxFit.cover,
                ),
              )
            else
              Center(child: ProductImage(product: widget.initial!, size: 220)),
            TextButton.icon(
              onPressed: _isSubmitting ? null : _showPhotoOptions,
              icon: const Icon(Icons.edit_outlined),
              label: const Text(AppTexts.changePhoto),
            ),
          ],
          if (_photoMissing)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                AppTexts.photoRequired,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: AppTexts.productName,
              hintText: AppTexts.productNameHint,
            ),
            validator: Validators.productName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _varietyController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: AppTexts.variety,
              hintText: AppTexts.varietyHint,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: AppTexts.quantity,
                    hintText: AppTexts.quantityHint,
                  ),
                  validator: Validators.quantity,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: const InputDecoration(labelText: AppTexts.unit),
                  items: AppConfig.units
                      .map(
                        (unit) =>
                            DropdownMenuItem(value: unit, child: Text(unit)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _unit = value ?? _unit),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: AppTexts.minimumPrice,
              hintText: AppTexts.minimumPriceHint,
              suffixText: AppTexts.fcfa,
            ),
            validator: Validators.minimumPrice,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: AppTexts.harvestDate,
              hintText: AppTexts.selectDate,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _selectHarvestDate,
            validator: (_) => Validators.harvestDate(_harvestDate),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: AppTexts.address,
              hintText: AppTexts.addressHint,
            ),
            validator: Validators.address,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(
              _isSubmitting
                  ? AppTexts.publishing
                  : _editing
                      ? AppTexts.save
                      : AppTexts.publish,
            ),
          ),
        ],
      ),
    );
  }
}
