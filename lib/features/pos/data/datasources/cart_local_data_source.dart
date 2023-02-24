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
  Future<Cart> addItems(Item itemToCache);
}

const CACHED_CART = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<Cart> getCart() {
    final jsonString = sharedPreferences.getString(CACHED_CART);

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = json.decode(jsonString);
      Cart cart;

      for (var item in jsonMap) {
        cart.items.add(Item.fromJson(item));
      }
      return Future.value(cart);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Cart> addItems(Item itemToCache) async {
    Cart cart = await getCart();
    cart.addItem(itemToCache);
    sharedPreferences.setString(
      CACHED_CART,
      json.encode(itemToCache.toJson()),
    );
    return cart;
  }
}
