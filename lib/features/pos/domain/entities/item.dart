import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String PLU_EAN;
  final String categoryId;
  final String unit;
  final double unitPrice;
  late double quantity;
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
    return amount * totalPercentage;
  }

  double get netAmount => amount - totalDiscount;
  //////////////////////////
  final String taxFormat;
  final String taxCategory;
  final Map<int, dynamic> taxMap;
  final String taxExeptionReasonCode;
  final String taxExeptionReason;
  List<int>? taxIds;
  double get taxPrice {
    double totalTax = 0;
    for (int taxId in taxIds!) {
      final tax = taxMap[taxId];
      if (tax != null) {
        final taxAmount = tax['amount'];
        final priceInclude = tax['price_include'];
        if (!priceInclude) {
          totalTax += netAmount * (taxAmount / 100);
        }
      }
    }
    return totalTax;
  }

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
    required this.taxMap,
    required this.taxExeptionReasonCode,
    required this.taxExeptionReason,
    required this.discountPercentages,
    required this.PLU_EAN,
    required this.categoryId,
    this.taxIds,
  });
  factory Item.custom(
      {required String name,
      required double price,
      required double quantity,
      required Map<int, dynamic> taxMap,
      required List<double> discountPercentages}) {
    return Item(
        taxMap: taxMap,
        id: const Uuid().v4(),
        name: name,
        PLU_EAN: "custom",
        categoryId: "custom",
        unitPrice: price,
        unit: "custom",
        taxCategory: "Standard",
        taxFormat: "%",
        taxExeptionReason: "",
        taxExeptionReasonCode: "",
        discountPercentages: discountPercentages,
        quantity: quantity);
  }

  Item.copyWithQuantity(Item source, double newQuantity)
      : id = source.id,
        name = source.name,
        unitPrice = source.unitPrice,
        quantity = newQuantity,
        PLU_EAN = source.PLU_EAN,
        categoryId = source.categoryId,
        discountPercentages = source.discountPercentages,
        taxCategory = source.taxCategory,
        taxExeptionReason = source.taxExeptionReason,
        taxExeptionReasonCode = source.taxExeptionReasonCode,
        taxFormat = source.taxFormat,
        taxMap = source.taxMap,
        unit = source.unit;
  Item.copyWithDiscount(Item source, List<double> newDiscounts)
      : id = source.id,
        name = source.name,
        unitPrice = source.unitPrice,
        quantity = source.quantity,
        PLU_EAN = source.PLU_EAN,
        categoryId = source.categoryId,
        discountPercentages = newDiscounts,
        taxCategory = source.taxCategory,
        taxExeptionReason = source.taxExeptionReason,
        taxExeptionReasonCode = source.taxExeptionReasonCode,
        taxFormat = source.taxFormat,
        taxMap = source.taxMap,
        unit = source.unit;
  static Item fromJsonOdoo(Map json, Map<int, dynamic> taxMap) {
      List<int> taxIds = [];
  
  if (json['taxes_id'] != null) {
    taxIds = (json['taxes_id'] as List).map((tax) {
      // Safely handle non-int values by using a null-aware operator and casting
      if (tax is int) {
        return tax;
      } else if (tax is String) {
        return int.tryParse(tax) ?? 0; // Attempt to parse if it's a string
      } else {
        return 0; // Default value if unable to cast
      }
    }).toList();
  }
    

    return Item(
        id: json['id'].toString(),
        name: json['name'],
        unit: 'kg',
        unitPrice: json['list_price'],
        taxIds: taxIds,
        taxFormat: '',
        taxCategory: '',
        taxMap: taxMap,
        taxExeptionReasonCode: '',
        taxExeptionReason: '',
        discountPercentages: const [],
        PLU_EAN: json['code'] != false ? json['code'] : '',
        categoryId: json['pos_categ_ids'].isNotEmpty
            ? json['pos_categ_ids'][0].toString()
            : '');
  }

  static Item fromJson(Map json, Map<int, dynamic>? taxMap) {
    return Item(
        name: json['name'],
        quantity: json['quantity'] != null ? json['quantity'].toDouble() : 1,
        PLU_EAN: json['PLU_EAN'],
        categoryId: json['categoryId'],
        unitPrice: json['unitPrice'].toDouble(),
        unit: json['unit'],
        id: json['_id'],
        taxCategory: json['taxCategory'] ?? 'Standard',
        taxExeptionReason: json['taxExeptionReason'] ?? '',
        taxExeptionReasonCode: json['taxExeptionReasonCode'] ?? '',
        taxMap: taxMap ?? {},
        taxFormat: json['taxFormat'] ?? '%',
        discountPercentages: json['discountPercentages'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': name,
      'quantity': quantity,
      'PLU_EAN': PLU_EAN,
      'categoryId': categoryId,
      'unitPrice': unitPrice,
      'unit': unit,
      'taxCategory': taxCategory,
      'taxExeptionReason': taxExeptionReason,
      'taxExeptionReasonCode': taxExeptionReasonCode,
      'taxFormat': taxFormat,
      'discountPercentages': discountPercentages,
      'discountAmount': totalDiscount,
      'amount': amount,
      "netAmount": netAmount,
      "taxAmount": taxPrice,
      "grossAmount": grossPrice,
    };
  }

  static Item fromSnapshot(snap, Map<int, dynamic>? taxMap) {
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
        taxMap: taxMap ?? {},
        taxFormat: snap['item']['taxFormat'] ?? '%',
        discountPercentages: snap['item']['discountPercentages'] ?? []);
  }

  @override
  List<Object?> get props =>
      [id, name, PLU_EAN, categoryId, unitPrice, unit, discountPercentages];
}
