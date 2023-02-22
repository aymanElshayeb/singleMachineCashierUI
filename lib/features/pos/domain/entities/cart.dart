import 'package:equatable/equatable.dart';
import 'item.dart';
import 'package:meta/meta.dart';

class Cart extends Equatable {
  List<Item> items;

  Cart({
    @required this.items,
  }) : super([items]);
  Future<List<Item>> addItem(Item item) async {
    items.add(item);
    return items;
  }

  factory Cart.fromJson(Map<String, dynamic> jsonMap) {
    return Cart(items: jsonMap['items']);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items,
    };
  }
}
