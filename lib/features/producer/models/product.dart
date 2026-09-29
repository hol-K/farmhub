import 'package:cloud_firestore/cloud_firestore.dart';

/// Récolte publiée (collection products/{id}). Modèle partagé producteur / acheteur.
class Product {
  const Product({
    this.id = '',
    required this.producerId,
    required this.producerName,
    required this.producerPhone,
    required this.name,
    this.variety = '',
    required this.quantity,
    required this.unit,
    required this.minPrice,
    required this.harvestDate,
    required this.address,
    this.photoUrl,
    this.createdAt,
    this.hasPendingWrites = false,
  });

  final String id;
  final String producerId;
  final String producerName;
  final String producerPhone;
  final String name;
  final String variety;
  final num quantity;
  final String unit;

  /// Prix minimum en FCFA.
  final int minPrice;
  final DateTime harvestDate;

  /// Texte libre (village, marché…). Pas de GPS.
  final String address;

  /// null tant que la photo n'est pas envoyée.
  final String? photoUrl;

  /// null tant que le serveur n'a pas reçu le produit.
  final DateTime? createdAt;

  /// true = « En attente d'envoi » (écriture pas encore reçue par le serveur).
  final bool hasPendingWrites;

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Product(
      id: doc.id,
      producerId: d['producerId'] as String,
      producerName: d['producerName'] as String? ?? '',
      producerPhone: d['producerPhone'] as String? ?? '',
      name: d['name'] as String? ?? '',
      variety: d['variety'] as String? ?? '',
      quantity: d['quantity'] as num? ?? 0,
      unit: d['unit'] as String? ?? '',
      minPrice: (d['minPrice'] as num? ?? 0).toInt(),
      harvestDate: (d['harvestDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: d['address'] as String? ?? '',
      photoUrl: d['photoUrl'] as String?,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      hasPendingWrites: doc.metadata.hasPendingWrites,
    );
  }

  /// Données à écrire dans Firestore (création). `createdAt` est posé par le serveur.
  Map<String, dynamic> toMap() => {
        'producerId': producerId,
        'producerName': producerName,
        'producerPhone': producerPhone,
        'name': name,
        'variety': variety,
        'quantity': quantity,
        'unit': unit,
        'minPrice': minPrice,
        'harvestDate': Timestamp.fromDate(harvestDate),
        'address': address,
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
