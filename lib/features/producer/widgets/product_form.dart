import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/utils/validators.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

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

  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedUnit;
  DateTime? _harvestDate;
  XFile? _selectedPhoto;

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectHarvestDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _harvestDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
    );

    if (selectedDate == null) return;

    setState(() {
      _harvestDate = selectedDate;
    });
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final photo = await _imagePicker.pickImage(
        source: source,
      );

      if (photo == null) return;

      setState(() {
        _selectedPhoto = photo;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppTexts.photoSelectionError),
        ),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text(AppTexts.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(AppTexts.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text(AppTexts.cancel),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removePhoto() {
    setState(() {
      _selectedPhoto = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_harvestDate == null) {
      setState(() {});
      return;
    }

    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: AppTexts.productName,
              hintText: AppTexts.productNameHint,
            ),
            validator: Validators.productName,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _varietyController,
            decoration: const InputDecoration(
              labelText: AppTexts.variety,
              hintText: AppTexts.varietyHint,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: AppTexts.quantity,
              hintText: AppTexts.quantityHint,
            ),
            validator: Validators.quantity,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _selectedUnit,
            decoration: const InputDecoration(
              labelText: AppTexts.unit,
            ),
            items: AppConfig.units
                .map(
                  (unit) => DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedUnit = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppTexts.unitRequired;
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: AppTexts.minimumPrice,
              hintText: AppTexts.minimumPriceHint,
              suffixText: AppTexts.fcfa,
            ),
            validator: Validators.minimumPrice,
          ),
          const SizedBox(height: 16),

          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: AppTexts.harvestDate,
              hintText: 'Sélectionner une date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: _harvestDate == null
                  ? ''
                  : '${_harvestDate!.day.toString().padLeft(2, '0')}/'
                      '${_harvestDate!.month.toString().padLeft(2, '0')}/'
                      '${_harvestDate!.year}',
            ),
            onTap: _selectHarvestDate,
            validator: (_) => Validators.harvestDate(_harvestDate),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: AppTexts.address,
              hintText: AppTexts.addressHint,
            ),
            validator: Validators.address,
          ),
          const SizedBox(height: 24),

          if (_selectedPhoto == null)
            OutlinedButton.icon(
              onPressed: _showPhotoOptions,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text(AppTexts.addPhoto),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedPhoto!.path),
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _removePhoto,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Supprimer la photo'),
                ),
              ],
            ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submit,
            child: const Text(AppTexts.publish),
          ),
        ],
      ),
    );
  }
}