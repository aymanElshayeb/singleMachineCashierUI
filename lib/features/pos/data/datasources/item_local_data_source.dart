import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class ItemLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<ItemModel>> getItems();
  Future<void> cacheItems(ItemModel itemToCache);
}

const CACHED_ITEMS = 'CACHED_ITEMS';

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final SharedPreferences sharedPreferences;

  ItemLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<ItemModel>> getItems() {
    final jsonString = [
      {
        "name": "potato",
        "id": 1,
        "unit": "Kilo",
        "kilo": true,
        "category": 1,
        "price": 20,
        "PLU_EAN": ""
      },
      {
        "name": "orange",
        "id": 2,
        "unit": "Kilo",
        "kilo": true,
        "category": 1,
        "price": 15,
        "PLU_EAN": ""
      },
      {
        "name": "banana",
        "id": 3,
        "unit": "Kilo",
        "category": 2,
        "kilo": true,
        "price": 10,
        "PLU_EAN": ""
      },
      {
        "name": "milk",
        "id": 4,
        "unit": "liter",
        "category": 2,
        "price": 10,
        "PLU_EAN": ""
      },
      {
        "name": "eggs",
        "id": 5,
        "unit": "piece",
        "kilo": false,
        "category": 2,
        "price": 3,
        "PLU_EAN": ""
      },
      {
        "name": "cheese",
        "id": 6,
        "unit": "Kilo",
        "kilo": true,
        "category": 2,
        "price": 15,
        "PLU_EAN": ""
      }
    ];

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<ItemModel> items = [];

      for (var item in jsonMap) {
        items.add(ItemModel.fromJson(item));
      }
      return Future.value(items);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheItems(ItemModel itemToCache) {
    return sharedPreferences.setString(
      CACHED_ITEMS,
      json.encode(itemToCache.toJson()),
    );
  }
}
