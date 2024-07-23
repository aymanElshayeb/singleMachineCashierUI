import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class OdooItemsDataSource implements ItemsDataSource {
  final String odooUrl = 'http://localhost:8069';
  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(
      {String? categoryId}) async {
    final Uri url = Uri.parse('$odooUrl/web/dataset/call_kw');
    const storage = FlutterSecureStorage();
    final String? sessionId = await storage.read(key: 'sessionId');
    if (sessionId == null) {
      return left(AuthenticationFailure());
    }
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "model": "product.product",
            "method": "search_read",
            "args": [],
            "kwargs": {
              "domain": [
                ["pos_categ_ids", "in", int.parse(categoryId!)]
              ],
              "fields": [
                "id",
                "name",
                "list_price",
                "barcode",
                "taxes_id",
                "pos_categ_ids",
                "code"
              ],
              "limit": 100
            }
          },
          "id": 3
        }));
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> itemsJson = jsonDecode(response.body)['result'];
      // Convert the JSON data to a list of Item objects
      final List<Item> items = List<Item>.from(
        itemsJson.map((item) => Item.fromJsonOdoo(item)),
      );

      List<Item> categoryItems = [];
      for (var item in items) {
        if (item.categoryId == categoryId) {
          categoryItems.add(item);
        }
      }

      return right(categoryItems);
    } else {
      final responseMap = jsonDecode(response.body);
      if (responseMap['message'] == 'Unauthorized: Invalid token') {
        return left(AuthenticationFailure());
      }
      // Handle errors
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItemsByEan(
      {required String keyWord}) async {
    final Uri url = Uri.parse('$odooUrl/web/dataset/call_kw');
    const storage = FlutterSecureStorage();
    final String? sessionId = await storage.read(key: 'sessionId');
    if (sessionId == null) {
      return left(AuthenticationFailure());
    }
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "model": "product.product",
            "method": "search_read",
            "args": [],
            "kwargs": {
              "domain": [
                ["default_code", "ilike", keyWord],
                ["available_in_pos", "=", true]
              ],
              "fields": [
                "id",
                "name",
                "list_price",
                "barcode",
                "taxes_id",
                "pos_categ_ids",
                "code"
              ],
              "limit": 100
            }
          },
          "id": 3
        }));
    if (response.statusCode == 200) {
      
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        final List<dynamic> itemsJson = responseBody['result'];
        final List<Item> items =
            itemsJson.map((item) => Item.fromJsonOdoo(item)).toList();
        return right(items);
      } else {
        return left(CacheFailure());
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['error']['message'] == 'Unauthorized: Invalid token') {
        return left(AuthenticationFailure());
      }
      return left(CacheFailure());
    }
  }
}