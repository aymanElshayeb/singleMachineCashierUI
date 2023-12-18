import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:single_machine_cashier_ui/core/error/failures.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import 'package:http/http.dart' as http;

class OfflineCategoryRepository implements CategoryRepository {
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final Uri url = Uri.parse('http://localhost:3000/category');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the response
        final List<dynamic> categoriesJson = jsonDecode(response.body);

        // Convert the JSON data to a list of Category objects
        final List<Category> categories = List<Category>.from(
          categoriesJson.map((category) => Category.fromJson(category)),
        );
      

      return right(categories);
    } else {
      // Handle errors
      return left(CacheFailure());
    }
  }
}
