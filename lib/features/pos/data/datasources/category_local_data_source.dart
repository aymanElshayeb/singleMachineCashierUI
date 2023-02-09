import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';

abstract class CategoryLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<CategoryModel>> getCategories();
  Future<void> cacheCategories(ItemModel itemToCache);
}

const CACHED_CATEGORIES = 'CACHED_CATEGORIES';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<CategoryModel>> getCategories() {
    final jsonString = [
      {"name": "groceries", "id": 1},
      {"name": "dairy", "id": 2},
      {"name": "games", "id": 3}
    ];

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<CategoryModel> categories = [];

      for (var category in jsonMap) {
        categories.add(CategoryModel.fromJson(category));
      }
      return Future.value(categories);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCategories(ItemModel itemToCache) {
    return sharedPreferences.setString(
      CACHED_CATEGORIES,
      json.encode(itemToCache.toJson()),
    );
  }
}
