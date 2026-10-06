import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';
import '../models/product.dart';
import '../providers.dart';
import '../widgets/product_form.dart';

/// Publication d'une récolte, ou modification si [productId] est fourni.
class PublishScreen extends ConsumerWidget {
  const PublishScreen({super.key, this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = productId;
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? AppTexts.publishTitle : AppTexts.editTitle),
      ),
      body: SafeArea(
        child: id == null
            ? _formList(ProductForm(onSubmit: (data) => _publish(context, ref, data)))
            : ref.watch(productProvider(id)).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const Center(child: Text(AppTexts.productLoadError)),
                  data: (product) => product == null
                      ? const Center(child: Text(AppTexts.productNotFound))
                      : _formList(ProductForm(
                          initial: product,
                          onSubmit: (data) => _update(context, product, data),
                        )),
                ),
      ),
    );
  }

  static Widget _formList(Widget form) =>
      ListView(padding: const EdgeInsets.all(16), children: [form]);

  static Product _fromForm(
    ProductFormData data, {
    required String producerId,
    required String producerName,
    required String producerPhone,
  }) =>
      Product(
        producerId: producerId,
        producerName: producerName,
        producerPhone: producerPhone,
        name: data.name,
        variety: data.variety,
        quantity: data.quantity,
        unit: data.unit,
        minPrice: data.minPrice,
        harvestDate: data.harvestDate,
        address: data.address,
      );

  Future<void> _publish(
    BuildContext context,
    WidgetRef ref,
    ProductFormData data,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final profile = ref.read(authProvider).value;
    if (profile == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppTexts.publishError)),
      );
      return;
    }

    final doc = FirebaseService.products.doc();
    final product = _fromForm(
      data,
      producerId: profile.uid,
      producerName: profile.name,
      producerPhone: profile.phone,
    );

    // Pas d'await : hors-ligne, Firestore garde l'écriture en cache et l'envoie
    // au retour du réseau (badge « En attente d'envoi » en attendant).
    doc.set(product.toMap()).ignore();
    //photo envoyée en arrière-plan, perdue si l'app est fermée hors-ligne ;
    // ajouter une file d'attente persistante si ça arrive sur le terrain.
    _uploadPhoto(doc, data.photo!.path).ignore();

    context.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text(AppTexts.publishSuccess)),
    );
  }

  Future<void> _update(
    BuildContext context,
    Product old,
    ProductFormData data,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final doc = FirebaseService.products.doc(old.id);
    final edited = _fromForm(
      data,
      producerId: old.producerId,
      producerName: old.producerName,
      producerPhone: old.producerPhone,
    );

    // Même logique hors-ligne que la publication : pas d'await.
    doc.update(edited.toEditableMap()).ignore();
    final photo = data.photo;
    if (photo != null) _uploadPhoto(doc, photo.path).ignore();

    context.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text(AppTexts.editSuccess)),
    );
  }

  static Future<void> _uploadPhoto(
    DocumentReference<Map<String, dynamic>> doc,
    String path,
  ) async {
    final task = await FirebaseService.productPhoto(doc.id).putFile(File(path));
    await doc.update({'photoUrl': await task.ref.getDownloadURL()});
  }
}
