import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class ItemLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<ItemModel>> getItems();
  Future<void> cacheItems (ItemModel itemToCache);
}

const CACHED_ITEMS = 'CACHED_ITEMS';

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final SharedPreferences sharedPreferences;

  ItemLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<ItemModel>> getItems() {
    final jsonString = sharedPreferences.getString(CACHED_ITEMS);

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = json.decode(jsonString);
      List<ItemModel> items;

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
