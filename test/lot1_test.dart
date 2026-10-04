import 'package:farmhub/core/providers/auth_provider.dart';
import 'package:farmhub/core/utils/extensions.dart';
import 'package:farmhub/features/auth/widgets/phone_input_field.dart';
import 'package:farmhub/features/buyer/product_filters.dart';
import 'package:farmhub/features/producer/models/product.dart';
import 'package:farmhub/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('numéro béninois', () {
    expect(validateBeninPhone('0197000000'), isNull);
    expect(validateBeninPhone('97000000'), isNotNull); // ancien format 8 chiffres
    expect(validateBeninPhone('0297000000'), isNotNull);
    expect(validateBeninPhone(''), isNotNull);
    expect(validateBeninPhone(null), isNotNull);
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
    expect(r('/buyer/product/x', role: UserRole.producer), '/producer');
    expect(r('/profile', role: UserRole.buyer), isNull);
  });

  test('format prix', () {
    expect(15000.fcfa.replaceAll(RegExp(r'\s'), ' '), '15 000 FCFA');
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
  });
}
