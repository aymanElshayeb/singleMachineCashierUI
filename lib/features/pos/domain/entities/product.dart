import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String PLU_EAN;
  final String categoryId;
  final String unit;
  final double unitPrice;
  double quantity;
  double get amount => unitPrice * quantity;
  //////////////////////////
  List<double>? discountPercentages;
  double get totalDiscount {
    double totalPercentage = 0.0;
    if (discountPercentages != null) {
      for (var discount in discountPercentages!) {
        totalPercentage += discount;
      }
    }
    return amount * (totalPercentage / 100);
  }

  double get netAmount => amount - totalDiscount;
  //////////////////////////
  final String taxFormat;
  final String taxCategory;
  final double taxPercentage;
  final String taxExeptionReasonCode;
  final String taxExeptionReason;
  double get taxPrice => netAmount * taxPercentage / 100;
  //////////////////////////
  double get grossPrice => taxPrice + netAmount;

  Item({
    required this.id,
    required this.name,
    required this.unit,
    required this.unitPrice,
    this.quantity = 1,
    required this.taxFormat,
    required this.taxCategory,
    required this.taxPercentage,
    required this.taxExeptionReasonCode,
    required this.taxExeptionReason,
    required this.discountPercentages,
    required this.PLU_EAN,
    required this.categoryId,
  });
  factory Item.custom(
      {required String name,
      required double price,
      required double quantity,
      required double taxPercentage}) {
    return Item(
        taxPercentage: taxPercentage,
        id: const Uuid().v4(),
        name: name,
        PLU_EAN: 'custom',
        categoryId: 'custom',
        unitPrice: price,
        unit: 'custom',
        taxCategory: 'Standard',
        taxFormat: '%',
        taxExeptionReason: '',
        taxExeptionReasonCode: '',
        discountPercentages: const [],
        quantity: quantity);
  }
  void addDiscount(double discountPercentage) {
    discountPercentages ??= [];
    discountPercentages!.add(discountPercentage);
  }

  void removeDiscount(double discountPercentage) {
    if (discountPercentages != null) {
      discountPercentages!.remove(discountPercentage);
    }
  }

  void editQuantity(double quantity) {
    if (quantity > 0) {
      this.quantity = quantity;
    }
  }

  static Item fromJson(Map json) {
    return Item(
        name: json['name'],
        quantity: json['quantity'].toDouble() ?? 1,
        PLU_EAN: json['PLU_EAN'],
        categoryId: json['categoryId'],
        unitPrice: json['unitPrice'].toDouble(),
        unit: json['unit'],
        id: json['_id'],
        taxCategory: json['taxCategory'],
        taxExeptionReason: json['taxExeptionReason'],
        taxExeptionReasonCode: json['taxExeptionReasonCode'],
        taxPercentage: json['taxPercentage'],
        taxFormat: json['taxFormat'],
        discountPercentages: json['discountPercentages'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'PLU_EAN': PLU_EAN,
      'categoryId': categoryId,
      'unitPrice': unitPrice,
      'unit': unit,
      'taxCategory': taxCategory,
      'taxExeptionReason': taxExeptionReason,
      'taxExeptionReasonCode': taxExeptionReasonCode,
      'taxPercentage': taxPercentage,
      'taxFormat': taxFormat,
      'discountPercentages': discountPercentages,
    };
  }

  static Item fromSnapshot(snap) {
    return Item(
        unitPrice: (snap['item']['unitPrice'] as num?)?.toDouble() ?? 0.0,
        unit: snap['item']['unit'] ?? '',
        quantity: snap['item']['quantity'] ?? 1,
        name: snap['item']['name'] ?? 'Unknown',
        PLU_EAN: snap['item']['PLU_EAN'] ?? '',
        categoryId: snap['item']['categoryId'] ?? '',
        id: snap.id,
        taxCategory: snap['item']['taxCategory'] ?? '',
        taxExeptionReason: snap['item']['taxExeptionReason'] ?? '',
        taxExeptionReasonCode: snap['item']['taxExeptionReasonCode'] ?? '',
        taxPercentage: snap['item']['taxPercentage'] ?? '',
        taxFormat: snap['item']['taxFormat'] ?? '%',
        discountPercentages: snap['item']['discountPercentages'] ?? []);
  }

  @override
  List<Object?> get props =>
      [id, name, PLU_EAN, categoryId, unitPrice, unit, discountPercentages];
}
