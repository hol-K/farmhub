import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/features/producer/models/product.dart';
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

  testWidgets(
    'Modification : formulaire prérempli, valide sans nouvelle photo',
    (tester) async {
      ProductFormData? sent;
      final old = Product(
        id: 'p1',
        producerId: 'u1',
        producerName: 'Awa',
        producerPhone: '+2290165656655',
        name: 'Riz',
        variety: 'Romanien',
        quantity: 50,
        unit: 'kg',
        minPrice: 750,
        // Plus vieux que la limite de 30 jours du calendrier.
        harvestDate: DateTime.now().subtract(const Duration(days: 90)),
        address: 'Calavi',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductForm(
                initial: old,
                onSubmit: (data) async => sent = data,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Riz'), findsOneWidget);
      expect(find.text('750'), findsOneWidget);
      await tester.enterText(find.text('750'), '900');

      final save = find.text(AppTexts.save);
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pump();

      expect(find.text(AppTexts.photoRequired), findsNothing);
      expect(sent?.minPrice, 900);
      expect(sent?.photo, isNull);
      expect(sent?.harvestDate, old.harvestDate);
    },
  );
}
