import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';

abstract class CartLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<CartModel> getCart();
  Future<CartModel> addItems(ItemModel itemToCache);
}

const CACHED_CART = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<CartModel> getCart() {
    final jsonString = sharedPreferences.getString(CACHED_CART);

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = json.decode(jsonString);
      CartModel cart;

      for (var item in jsonMap) {
        cart.items.add(ItemModel.fromJson(item));
      }
      return Future.value(cart);
    } else {
      throw CacheException();
    }
  }


  @override
  Future<CartModel> addItems(ItemModel itemToCache) async {
    CartModel cart = await getCart();
    cart.addItem(itemToCache);
    sharedPreferences.setString(
      CACHED_CART,
      json.encode(itemToCache.toJson()),
    );
    return cart;
  }
}
