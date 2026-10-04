import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';
import '../models/product.dart';
import '../widgets/product_form.dart';

class PublishScreen extends ConsumerWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.publishTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProductForm(onSubmit: (data) => _publish(context, ref, data)),
          ],
        ),
      ),
    );
  }

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
    final product = Product(
      producerId: profile.uid,
      producerName: profile.name,
      producerPhone: profile.phone,
      name: data.name,
      variety: data.variety,
      quantity: data.quantity,
      unit: data.unit,
      minPrice: data.minPrice,
      harvestDate: data.harvestDate,
      address: data.address,
    );

    // Pas d'await : hors-ligne, Firestore garde l'écriture en cache et l'envoie
    // au retour du réseau (badge « En attente d'envoi » en attendant).
    doc.set(product.toMap()).ignore();
    //photo envoyée en arrière-plan, perdue si l'app est fermée hors-ligne ;
    // ajouter une file d'attente persistante si ça arrive sur le terrain.
    _uploadPhoto(doc, data.photo.path).ignore();

    context.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text(AppTexts.publishSuccess)),
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
