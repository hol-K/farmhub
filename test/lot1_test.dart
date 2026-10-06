import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/core/constants/countries.dart';
import 'package:farmhub/core/providers/auth_provider.dart';
import 'package:farmhub/core/utils/extensions.dart';
import 'package:farmhub/features/auth/widgets/phone_input_field.dart';
import 'package:farmhub/features/buyer/product_filters.dart';
import 'package:farmhub/features/producer/models/product.dart';
import 'package:farmhub/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('numéro béninois', () {
    const bj = Countries.benin;
    expect(validatePhone(bj, '0197000000'), isNull);
    expect(validatePhone(bj, '97000000'), isNotNull); // ancien format 8 chiffres
    expect(validatePhone(bj, '0297000000'), isNotNull);
    expect(validatePhone(bj, ''), isNotNull);
    expect(validatePhone(bj, null), isNotNull);
    expect(bj.toE164('0165656655'), '+2290165656655');
  });

  test('numéros des autres pays', () {
    Country c(String name) => Countries.all.firstWhere((c) => c.name == name);

    // Nigeria : le 0 national est retiré.
    expect(c('Nigeria').toE164('08031234567'), '+2348031234567');
    expect(c('Nigeria').toE164('8031234567'), '+2348031234567');
    expect(c('Nigeria').toE164('0803123'), isNull);
    // Togo : 8 chiffres.
    expect(c('Togo').toE164('90123456'), '+22890123456');
    expect(c('Togo').toE164('9012345'), isNull);
    // Côte d'Ivoire : le 0 fait partie du numéro (10 chiffres).
    expect(c('Côte d\'Ivoire').toE164('0701020304'), '+2250701020304');
    // Liberia : 8 ou 9 chiffres.
    expect(c('Liberia').toE164('0770123456'), '+231770123456');
    expect(c('Liberia').toE164('22123456'), '+23122123456');
    expect(validatePhone(c('Togo'), '123'), AppTexts.phoneInvalidFor('Togo'));
  });

  test('redirections', () {
    String? r(String loc, {bool loading = false, bool signedIn = true, UserRole? role}) =>
        authRedirect(loc, loading: loading, signedIn: signedIn, role: role);

    expect(r('/login', loading: true), '/');
    expect(r('/', loading: true), isNull);
    expect(r('/producer', signedIn: false), '/login');
    expect(r('/otp', signedIn: false), isNull);
    expect(r('/producer'), '/role');
    expect(r('/role'), isNull);
    expect(r('/role', role: UserRole.producer), '/producer');
    expect(r('/otp', role: UserRole.buyer), '/buyer');
    expect(r('/producer/publish', role: UserRole.producer), isNull);
    expect(r('/producer/publish', role: UserRole.buyer), '/buyer');
    expect(r('/producer/product/x/edit', role: UserRole.producer), isNull);
    expect(r('/producer/product/x/edit', role: UserRole.buyer), '/buyer');
    expect(r('/buyer/product/x', role: UserRole.producer), '/producer');
    expect(r('/profile', role: UserRole.buyer), isNull);

    // Onboarding : premier lancement, déconnecté uniquement.
    String? first(String loc, {bool signedIn = false}) => authRedirect(
          loc,
          loading: false,
          signedIn: signedIn,
          role: UserRole.buyer,
          onboarded: false,
        );
    expect(first('/login'), '/onboarding');
    expect(first('/onboarding'), isNull);
    expect(first('/buyer', signedIn: true), isNull);
  });

  test('format prix', () {
    String clean(String s) => s.replaceAll(RegExp(r'\s'), ' ');
    expect(clean(15000.money('XOF')), '15 000 FCFA');
    expect(clean(5000.money('NGN')), '5 000 ₦');
    expect(clean(10.money('???')), '10 ???'); // code inconnu : affiché tel quel

    // La monnaie suit le pays du numéro.
    expect(Countries.fromPhone('+2290165656655').currency, 'XOF');
    expect(Countries.fromPhone('+2348031234567').currency, 'NGN');
    expect(Countries.fromPhone('+22890123456').currency, 'XOF'); // Togo
    expect(Countries.fromPhone('').currency, 'XOF');
  });

  test('filtre des produits acheteur par nom, variété et lieu', () {
    final now = DateTime(2026, 10, 1);
    final products = [
      Product(
        producerId: 'p1',
        producerName: 'Mamadou',
        producerPhone: '97000000',
        name: 'Tomates',
        quantity: 20,
        unit: 'kg',
        minPrice: 2500,
        harvestDate: now,
        address: 'Parakou',
      ),
      Product(
        producerId: 'p2',
        producerName: 'Aissata',
        producerPhone: '97000001',
        name: 'Poivrons',
        variety: 'Rouge',
        quantity: 12,
        unit: 'kg',
        minPrice: 3000,
        harvestDate: now,
        address: 'Cotonou',
      ),
    ];

    expect(filterProductsByQuery(products, 'tomate'), [products[0]]);
    expect(filterProductsByQuery(products, 'rouge'), [products[1]]);
    expect(filterProductsByQuery(products, 'parakou'), [products[0]]);
    expect(filterProductsByQuery(products, 'maïs'), isEmpty);

    // Filtres unité / prix max et tri.
    expect(applyBuyerFilters(products, maxPrice: 2500), [products[0]]);
    expect(applyBuyerFilters(products, unit: 'sac'), isEmpty);
    expect(
      applyBuyerFilters(products, sort: ProductSort.priceDesc),
      [products[1], products[0]],
    );
    expect(
      applyBuyerFilters(products, sort: ProductSort.priceAsc),
      [products[0], products[1]],
    );

    // Monnaies : prix max dans la monnaie de l'acheteur, produits étrangers après.
    final naira = Product(
      producerId: 'p3',
      producerName: 'Tunde',
      producerPhone: '+2348031234567',
      name: 'Igname',
      quantity: 5,
      unit: 'sac',
      minPrice: 100,
      currency: 'NGN',
      harvestDate: now,
      address: 'Lagos',
    );
    final mixed = [...products, naira];
    expect(applyBuyerFilters(mixed, maxPrice: 2500), [products[0]]);
    expect(
      applyBuyerFilters(mixed, sort: ProductSort.priceAsc),
      [products[0], products[1], naira],
    );
    expect(
      applyBuyerFilters(mixed, maxPrice: 500, currency: 'NGN'),
      [naira],
    );
    expect(naira.priceLabel.replaceAll(RegExp(r'\s'), ' '), '100 ₦');
  });
}
