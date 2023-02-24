import 'package:meta/meta.dart';

import '../../domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({
    @required String name,
    @required int id,
    @required String unit,
    @required bool kilo,
    @required int category,
    @required num price,
    @required String PLU_EAN,
  }) : super(
            name: name,
            id: id,
            unit: unit,
            kilo: kilo,
            category: category,
            price: price,
            PLU_EAN: PLU_EAN);

  factory ItemModel.fromJson(Map<String, dynamic> jsonMap) {
    return ItemModel(
        name: jsonMap['name'],
        id: jsonMap['id'],
        unit: jsonMap['unit'],
        kilo: jsonMap['kilo'],
        category: jsonMap['category'],
        price: jsonMap['price'],
        PLU_EAN: jsonMap['PLU_EAN']);
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
