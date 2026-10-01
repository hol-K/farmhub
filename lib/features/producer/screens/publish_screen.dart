import 'package:flutter/material.dart';

import '../../../core/constants/app_texts.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 2.
class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.publishTitle)),
      body: const Center(
        child: Text(AppTexts.publishPlaceholder, textAlign: TextAlign.center),
      ),
    );
  }
}
