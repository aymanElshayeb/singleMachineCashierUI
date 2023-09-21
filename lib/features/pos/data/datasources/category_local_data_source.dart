import 'dart:convert';
import 'package:meta/meta.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../main.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<Category>> getCategories();
}

const CACHED_CATEGORIES = 'CACHED_CATEGORIES';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl();

  @override
  Future<List<Category>> getCategories() async {
    List<Category> categories2 = [];
    return Future.value(categories2);
  }
}
