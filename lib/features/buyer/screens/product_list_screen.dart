import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 4. Accueil acheteur.
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.harvestsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppTexts.searchTitle,
            onPressed: () => context.push('/buyer/search'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: AppTexts.profileTitle,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: () => context.push('/buyer/product/demo'),
          child: const Text(
            AppTexts.harvestsPlaceholder,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
