import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/item.dart';

abstract class CartLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<Cart> getCart();
  Future<Cart> addItems(Item itemToCache, num quantity);
}

const CACHED_CART = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  Map<String, Object> jsonString = {
    'items': [
      Item(PLU_EAN: 'abdfsa', name: 'just for test item', price: 5, id: 5642)
    ],
    'quantities': [1],
  };

  CartLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<Cart> getCart() {
    //final jsonString = sharedPreferences.getString(CACHED_CART);

    if (jsonString != null) {
      final Map<String, Object> jsonMap = jsonString;
      //final List<Map<Object, Object>> jsonMap = json.decode(jsonString);
      Cart cart =
          Cart(items: jsonMap['items'], quantities: jsonMap['quantities']);

      return Future.value(cart);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Cart> addItems(Item itemToCache, num quantity) async {
    //Cart cart = await getCart();
    List<Item> items = jsonString['items'];
    List<num> quantities = jsonString['quantities'];
    bool found = false;
    for (int i = 0; i < jsonString.length; i++) {
      if (items[i] == itemToCache) {
        quantities[i] = quantity;
      }
    }
    if (!found) {
      items.add(itemToCache);
      quantities.add(quantity);
    }
    jsonString['items'] = items;
    jsonString['quantities'] = quantities;

    return Cart(items: items, quantities: quantities);
  }
}
