import 'package:equatable/equatable.dart';
import 'item.dart';
import 'package:meta/meta.dart';

class Cart extends Equatable {
  List<Item> items;
  List<num> quantities;

  Cart({
    @required this.items,
    @required this.quantities,
  }) : super([items, quantities]);

  // Future<List<Item>> addItem(Item item) async {
  //   items.add(item);
  //   return items;
  // }

  factory Cart.fromJson(Map<String, Object> jsonMap) {
    return Cart(items: jsonMap['items'], quantities: jsonMap['quantities']);
  }

  Map<Object, Object> toJson() {
    return {'items': items, 'quantites': quantities};
  }
}
