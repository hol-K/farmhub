import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';
import '../models/product.dart';
import '../widgets/product_form.dart';

class PublishScreen extends ConsumerStatefulWidget {
  const PublishScreen({super.key});

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  bool _isPublishing = false;

  Future<void> _publishProduct(ProductFormData data) async {
    final appUser = ref.read(authProvider).value;

    if (appUser == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible de récupérer les informations du producteur.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isPublishing = true;
    });

    DocumentReference<Map<String, dynamic>>? productRef;

    try {
      // 1. Générer l'identifiant du produit avant l'enregistrement.
      productRef = FirebaseService.products.doc();

      final product = Product(
        id: productRef.id,
        producerId: appUser.uid,
        producerName: appUser.name,
        producerPhone: appUser.phone,
        name: data.name,
        variety: data.variety,
        quantity: data.quantity,
        unit: data.unit,
        minPrice: data.minPrice,
        harvestDate: data.harvestDate,
        address: data.address,
        photoUrl: null,
      );

      // 2. Créer le document Firestore.
      await productRef.set(product.toMap());

      // 3. Envoyer la photo compressée vers Firebase Storage.
      final photoRef = FirebaseService.productPhoto(productRef.id);

      await photoRef.putFile(
        File(data.photo.path),
      );

      // 4. Récupérer l'URL publique/authentifiée de la photo.
      final photoUrl = await photoRef.getDownloadURL();

      // 5. Enregistrer l'URL dans le document Firestore.
      await productRef.update({
        'photoUrl': photoUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppTexts.publishSuccess),
        ),
      );
    } catch (_) {
      // Si l'upload échoue après la création du document,
      // on supprime le document incomplet.
      if (productRef != null) {
        try {
          await productRef.delete();
        } catch (_) {
          // On ignore une éventuelle erreur de nettoyage.
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppTexts.publishError),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.publishTitle),
      ),
      body: authState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          child: Text(
            'Impossible de charger votre profil.',
            textAlign: TextAlign.center,
          ),
        ),
        data: (appUser) {
          if (appUser == null) {
            return const Center(
              child: Text(
                'Vous devez être connecté pour publier une récolte.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AbsorbPointer(
              absorbing: _isPublishing,
              child: ProductForm(
                onSubmit: _publishProduct,
              ),
            ),
          );
        },
      ),
    );
  }
}