import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/features/producer/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    '« Publier » sur formulaire vide affiche les erreurs sans envoyer',
    (tester) async {
      var submitted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductForm(onSubmit: (_) async => submitted = true),
            ),
          ),
        ),
      );

      final publish = find.text(AppTexts.publish);
      await tester.ensureVisible(publish);
      await tester.tap(publish);
      await tester.pump();

      for (final error in [
        AppTexts.photoRequired,
        AppTexts.productNameRequired,
        AppTexts.quantityRequired,
        AppTexts.minimumPriceRequired,
        AppTexts.harvestDateRequired,
        AppTexts.addressRequired,
      ]) {
        expect(find.text(error), findsOneWidget, reason: error);
      }
      expect(submitted, isFalse);
    },
  );
}
