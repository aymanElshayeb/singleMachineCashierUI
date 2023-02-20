import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<Category>> getCategories();
  Future<void> cacheCategories(Item itemToCache);
}

const CACHED_CATEGORIES = 'CACHED_CATEGORIES';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<Category>> getCategories() {
    final jsonString = [
      {"name": "groceries", "id": 1},
      {"name": "dairy", "id": 2},
      {"name": "games", "id": 3}
    ];

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<Category> categories = [];

      for (var category in jsonMap) {
        categories.add(Category.fromJson(category));
      }
      return Future.value(categories);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCategories(Item itemToCache) {
    return sharedPreferences.setString(
      CACHED_CATEGORIES,
      json.encode(itemToCache.toJson()),
    );
  }
}
