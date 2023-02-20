import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/item.dart';

abstract class ItemLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<Item>> getItems();
  Future<void> cacheItems(Item itemToCache);
}

const CACHED_ITEMS = 'CACHED_ITEMS';

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final SharedPreferences sharedPreferences;

  ItemLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<Item>> getItems() {
    final jsonString = [
      {
        "name": "potato",
        "id": 1,
        "unit": "Kilo",
        "kilo": true,
        "category": 1,
        "price": 20,
        "PLU_EAN": "aa"
      },
      {
        "name": "orange",
        "id": 2,
        "unit": "Kilo",
        "kilo": true,
        "category": 1,
        "price": 15.5,
        "PLU_EAN": "bb"
      },
      {
        "name": "banana",
        "id": 3,
        "unit": "Kilo",
        "category": 2,
        "kilo": true,
        "price": 10,
        "PLU_EAN": "acc"
      },
      {
        "name": "milk",
        "id": 4,
        "unit": "liter",
        "category": 2,
        "price": 10,
        "PLU_EAN": "dd"
      },
      {
        "name": "eggs",
        "id": 5,
        "unit": "piece",
        "kilo": false,
        "category": 2,
        "price": 3,
        "PLU_EAN": "ff"
      },
      {
        "name": "cheese",
        "id": 6,
        "unit": "Kilo",
        "kilo": true,
        "category": 2,
        "price": 15,
        "PLU_EAN": "gg"
      }
    ];

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<Item> items = [];

      for (var item in jsonMap) {
        items.add(Item.fromJson(item));
      }
      return Future.value(items);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheItems(Item itemToCache) {
    return sharedPreferences.setString(
      CACHED_ITEMS,
      json.encode(itemToCache.toJson()),
    );
  }
}
