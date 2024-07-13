import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:single_machine_cashier_ui/core/error/failures.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import 'package:http/http.dart' as http;

class OfflineCategoryRepository implements CategoryRepository {
  final posEndpoint = const String.fromEnvironment('POS_ENDPOINT');
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final Uri url = Uri.parse('$posEndpoint/category');
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> categoriesJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Category objects
      final List<Category> categories = List<Category>.from(
        categoriesJson.map((category) => Category.fromJson(category)),
      );

      return right(categories);
    } else {
      final responseMap = jsonDecode(response.body);
      if (responseMap['message'] == 'Unauthorized: Invalid token') {
        return left(AuthenticationFailure());
      }
      // Handle errors
      return left(CacheFailure());
    }
  }
}
