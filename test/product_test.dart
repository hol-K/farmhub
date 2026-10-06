import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmhub/features/producer/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('une modification ne touche ni propriétaire, ni date de publication, ni statut', () {
    final harvest = DateTime(2026, 10, 1);
    final map = Product(
      producerId: 'u1',
      producerName: 'Awa',
      producerPhone: '+2290165656655',
      name: 'Riz',
      variety: 'Romanien',
      quantity: 50,
      unit: 'kg',
      minPrice: 900,
      harvestDate: harvest,
      address: 'Calavi',
      sold: true,
    ).toEditableMap();

    expect(map.keys.toSet(), {
      'name',
      'variety',
      'quantity',
      'unit',
      'minPrice',
      'harvestDate',
      'address',
    });
    expect(map['minPrice'], 900);
    expect(map['harvestDate'], Timestamp.fromDate(harvest));
  });
}
