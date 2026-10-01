import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 3. Accueil producteur.
class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.myProductsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: AppTexts.profileTitle,
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: () => context.push('/producer/product/demo'),
          child: const Text(
            AppTexts.myProductsPlaceholder,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/producer/publish'),
        icon: const Icon(Icons.add),
        label: const Text(AppTexts.publishFab),
      ),
    );
  }
}
