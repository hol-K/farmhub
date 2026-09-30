export '../../producer/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String variety;
  final String location;
  final double price;
  final double quantity;
  final String unit;
  final String phone;
  final String farmerName;
  final String description;
  final String imageUrl;
  final bool isAvailable;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.variety,
    required this.location,
    required this.price,
    required this.quantity,
    required this.phone,
    this.unit = 'kg',
    this.farmerName = '',
    this.description = '',
    this.imageUrl = '',
    this.isAvailable = true,
    this.createdAt,
  });

  /// Crée un Product à partir d'un document Firestore.
  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Product.fromMap(data, id: doc.id);
  }

  /// Crée un Product à partir d'une Map (utile aussi pour un cache local).
  factory Product.fromMap(Map<String, dynamic> data, {required String id}) {
    final created = data['createdAt'];
    return Product(
      id: id,
      name: (data['name'] ?? '') as String,
      variety: (data['variety'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      quantity: (data['quantity'] as num?)?.toDouble() ?? 0,
      unit: (data['unit'] ?? 'kg') as String,
      phone: (data['phone'] ?? '') as String,
      farmerName: (data['farmerName'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? '') as String,
      isAvailable: (data['isAvailable'] ?? true) as bool,
      createdAt: created is Timestamp ? created.toDate() : null,
    );
  }

  /// Convertit le Product en Map pour l'écriture dans Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'variety': variety,
      'location': location,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'phone': phone,
      'farmerName': farmerName,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// Utilisé par la recherche : nom, variété ou localisation.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        variety.toLowerCase().contains(q) ||
        location.toLowerCase().contains(q);
  }
}