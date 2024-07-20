import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OdooCategoryDataSource implements CategoryDataSource {
  final String odooUrl = 'http://localhost:8069';
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final Uri url = Uri.parse('$odooUrl/web/dataset/call_kw');
    const storage = FlutterSecureStorage();
    final String? sessionId = await storage.read(key: 'sessionId');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "model": "product.category",
            "method": "search_read",
            "args": [
              [],
              ["id", "name"]
            ],
            "kwargs": {}
          },
          "id": null
        }));
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> categoriesJson = jsonDecode(response.body)['result'];

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
