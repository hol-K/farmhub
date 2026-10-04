import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';

class PublishScreen extends ConsumerStatefulWidget {
  const PublishScreen({super.key});

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _quantityController = TextEditingController(text: '10');
  final _priceController = TextEditingController(text: '2500');
  final _addressController = TextEditingController();

  final _picker = ImagePicker();
  XFile? _pickedImage;
  String? _pickedImageName;

  String _unit = AppConfig.units.first;
  DateTime _harvestDate = DateTime.now().add(const Duration(days: 3));
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Publier une récolte')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: _pickedImage == null
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 42),
                            SizedBox(height: 8),
                            Text('Ajouter une photo'),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            if (_pickedImageName != null) ...[
              const SizedBox(height: 8),
              Text(_pickedImageName!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du produit'),
              validator: (input) => (input == null || input.trim().isEmpty) ? 'Obligatoire' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _varietyController,
              decoration: const InputDecoration(labelText: 'Variété (optionnel)'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantité'),
                    validator: (input) => (input == null || input.trim().isEmpty) ? 'Obligatoire' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(labelText: 'Unité'),
                    items: AppConfig.units
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                        .toList(),
                    onChanged: (value) => setState(() => _unit = value ?? AppConfig.units.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prix minimum (FCFA)'),
              validator: (input) => (input == null || input.trim().isEmpty) ? 'Obligatoire' : null,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _harvestDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _harvestDate = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Récolte prévue'),
                child: Text(_harvestDate.toLocal().toString().split(' ')[0]),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Localisation'),
              validator: (input) => (input == null || input.trim().isEmpty) ? 'Obligatoire' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : () => _submit(profile),
              icon: const Icon(Icons.check),
              label: Text(_saving ? 'Publication...' : 'Publier'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    setState(() {
      _pickedImage = picked;
      _pickedImageName = picked.name;
    });
  }

  Future<void> _submit(AppUser? profile) async {
    if (profile == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté pour publier.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);

    try {
      final productRef = await FirebaseService.products.add({
        'producerId': profile.uid,
        'producerName': profile.name,
        'producerPhone': profile.phone,
        'name': _nameController.text.trim(),
        'variety': _varietyController.text.trim(),
        'quantity': num.tryParse(_quantityController.text.trim()) ?? 0,
        'unit': _unit,
        'minPrice': int.tryParse(_priceController.text.trim()) ?? 0,
        'harvestDate': _harvestDate,
        'address': _addressController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (_pickedImage != null) {
        final file = File(_pickedImage!.path);
        final compressed = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 70,
          format: CompressFormat.jpeg,
        );

        if (compressed != null) {
          final storageRef = FirebaseService.productPhoto(productRef.id);
          final uploadTask = await storageRef.putFile(File(compressed.path));
          final url = await uploadTask.ref.getDownloadURL();
          await productRef.update({'photoUrl': url});
        }
      }

      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit publié avec succès.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la publication : $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
