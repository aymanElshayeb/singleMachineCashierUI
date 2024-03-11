import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firedart/firestore/models.dart';
import 'package:uuid/uuid.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String PLU_EAN;
  final String categoryId;
  final double price;
  final String unit;
  final double vat;
  final double quantity;
  final List<double>? discountsPercentage;

  const Item({
    this.vat = 0,
    required this.name,
    this.id = '0',
    required this.PLU_EAN,
    required this.categoryId,
    required this.price,
    required this.unit,
    this.quantity = 1,
    this.discountsPercentage,
  });
  factory Item.custom(
      {required String name,
      required double price,
      required double quantity,
      required double vat}) {
    return Item(
        vat: vat,
        id: const Uuid().v4(),
        name: name,
        PLU_EAN: 'custom',
        categoryId: 'custom',
        price: price,
        unit: 'custom',
        quantity: quantity);
  }

  @override
  List<Object?> get props =>
      [id, name, PLU_EAN, categoryId, price, unit, discountsPercentage];
  static Item fromSnapshot(Document snap) {
    return Item(
      name: snap['item']['name'] ?? 'Unknown',
      id: snap.id,
      PLU_EAN: snap['item']['PLU_EAN'] ?? '',
      categoryId: snap['item']['categoryId'] ?? '',
      price: (snap['item']['price'] as num?)?.toDouble() ?? 0.0,
      unit: snap['item']['unit'] ?? '',
      quantity: snap['item']['quantity'] ?? 1,
      vat: (snap['item']['vat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Item firebaseFromSnapshot(DocumentSnapshot snap) {
    return Item(
      name: snap['item']['name'] ?? 'Unknown',
      id: snap.id,
      PLU_EAN: snap['item']['PLU_EAN'] ?? '',
      categoryId: snap['item']['categoryId'] ?? '',
      price: (snap['item']['price'] as num?)?.toDouble() ?? 0.0,
      vat: (snap['item']['vat'] as num?)?.toDouble() ?? 0.0,
      unit: snap['item']['unit'] ?? '',
      quantity: snap['item']['quantity'] ?? 1,
      
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'PLU_EAN': PLU_EAN,
      'categoryId': categoryId,
      'price': price.toString(),
      'unit': unit,
      'quantity': quantity,
      'discounts': discountsPercentage,
      'vat': vat,
    };
  }

  double getTotalDiscount() {
    double totalDiscounts = 1;
    if (discountsPercentage != null) {
      for (var i = 0; i < discountsPercentage!.length; i++) {
        totalDiscounts *= 1 - discountsPercentage![i];
      }
    }
    return totalDiscounts;
  }

  double getNetPrice() {
    return price * quantity * getTotalDiscount();
  }

  double getGross() => getNetPrice() - vat;

  Item copyWith({
    String? name,
    String? PLU_EAN,
    String? categoryId,
    double? price,
    double? vat,
    String? unit,
    double? quantity,
    List<double>? discountsPercentage,
  }) {
    return Item(
        id: id,
        name: name ?? this.name,
        PLU_EAN: PLU_EAN ?? this.PLU_EAN,
        categoryId: categoryId ?? this.categoryId,
        price: price ?? this.price,
        vat: vat ?? this.vat,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        discountsPercentage: discountsPercentage ?? this.discountsPercentage);
  }

  Item.copyWithQuantity(Item source, double newQuantity)
      : id = source.id,
        name = source.name,
        price = source.price,
        vat = source.vat,
        quantity = newQuantity,
        PLU_EAN = source.PLU_EAN,
        categoryId = source.categoryId,
        discountsPercentage = source.discountsPercentage,
        unit = source.unit;

  Item.copyWithDiscount(Item source, List<double> newDiscounts)
      : id = source.id,
        name = source.name,
        price = source.price,
        vat = source.vat,
        quantity = source.quantity,
        PLU_EAN = source.PLU_EAN,
        categoryId = source.categoryId,
        discountsPercentage = newDiscounts,
        unit = source.unit;
  static Item fromJson(Map json) {
    return Item(
        name: json['name'],
        PLU_EAN: json['PLU_EAN'],
        categoryId: json['categoryId'],
        price: json['price'].toDouble(),
        vat: json['vat'].toDouble(),
        unit: json['unit'],
        id: json['_id']);
  }
}
