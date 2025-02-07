import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:http/http.dart' as http;

class NodeItemsDataSource implements ItemsDataSource {
      final posEndpoint = const String.fromEnvironment('POS_ENDPOINT');
  
  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(
      {String? categoryId}) async {
    final Uri url = Uri.parse('$posEndpoint/item');
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> itemsJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Item objects
      final List<Item> items = List<Item>.from(
        itemsJson.map((item) => Item.fromJson(item,{})),
      );
      if (categoryId != null) {
        List<Item> categoryItems = [];
        for (var item in items) {
          if (item.categoryId == categoryId) {
            categoryItems.add(item);
          }
        }

        return right(categoryItems);
      }

      return right(items);
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
    final Uri url = Uri.parse('$posEndpoint/item');
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> itemsJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Item objects
      final List<Item> items = List<Item>.from(
        itemsJson.map((item) => Item.fromJson(item,{})),
      );
      List<Item> eanItems = [];
      for (var item in items) {
        if (item.PLU_EAN.contains(keyWord)) {
          eanItems.add(item);
        }
      }

      return right(eanItems);
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