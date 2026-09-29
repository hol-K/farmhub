import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 4. Accueil acheteur.
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Récoltes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/buyer/search'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: () => context.push('/buyer/product/demo'),
          child: const Text('À faire — Lot 4\n(voir un détail)', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
