import 'package:meta/meta.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';

import '../../domain/entities/cart.dart';


class CartModel extends Cart {

  CartModel({
    @required List<ItemModel> items,
  }) : super( items:items);

  Future<List<Item>> addItem(Item item)async {
    items.add(item);
    return items;
  }

  factory CartModel.fromJson(Map<String, dynamic> jsonMap) {
    return CartModel( items: jsonMap['items']);
  }

  Map<String, dynamic> toJson() {
    return {
      'items':items,
    };
  }
}
