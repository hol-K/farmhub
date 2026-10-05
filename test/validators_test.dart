import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/core/utils/extensions.dart';
import 'package:farmhub/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseQuantity accepte la virgule française', () {
    expect(Validators.parseQuantity('12,5'), 12.5);
    expect(Validators.parseQuantity(' 12.5 '), 12.5);
    expect(Validators.parseQuantity('20'), 20);
    expect(Validators.parseQuantity('abc'), isNull);
    expect(Validators.parseQuantity(null), isNull);
  });

  test('quantité', () {
    expect(Validators.quantity('12,5'), isNull);
    expect(Validators.quantity(''), AppTexts.quantityRequired);
    expect(Validators.quantity('  '), AppTexts.quantityRequired);
    expect(Validators.quantity('0'), AppTexts.quantityInvalid);
    expect(Validators.quantity('-3'), AppTexts.quantityInvalid);
    expect(Validators.quantity('abc'), AppTexts.quantityInvalid);
  });

  test('prix minimum', () {
    expect(Validators.minimumPrice('2500'), isNull);
    expect(Validators.minimumPrice(null), AppTexts.minimumPriceRequired);
    expect(Validators.minimumPrice('0'), AppTexts.minimumPriceInvalid);
    expect(Validators.minimumPrice('12,5'), AppTexts.minimumPriceInvalid);
  });

  test('nom, date et adresse obligatoires', () {
    expect(Validators.productName('Tomates'), isNull);
    expect(Validators.productName('  '), AppTexts.productNameRequired);
    expect(Validators.harvestDate(DateTime(2026, 10, 5)), isNull);
    expect(Validators.harvestDate(null), AppTexts.harvestDateRequired);
    expect(Validators.address('Parakou'), isNull);
    expect(Validators.address(''), AppTexts.addressRequired);
  });

  test('format téléphone', () {
    expect('+229 01 97-00'.digitsOnly, '229019700');
    expect('+2290197000000'.phoneFr, '+229 01 97 00 00 00');
    expect('97000000'.phoneFr, '97000000'); // ancien format : inchangé
  });
}
