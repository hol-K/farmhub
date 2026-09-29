import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 3. Accueil producteur.
class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: () => context.push('/producer/product/demo'),
          child: const Text('À faire — Lot 3\n(voir un détail)', textAlign: TextAlign.center),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/producer/publish'),
        icon: const Icon(Icons.add),
        label: const Text('Publier'),
      ),
    );
  }
}
