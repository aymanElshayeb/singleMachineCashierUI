import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/item_repository.dart';
import 'package:http/http.dart' as http;

class OfflineItemRepository implements ItemsRepository {
  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(
      {String? categoryId}) async {
    final Uri url = Uri.parse('http://localhost:3000/item');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> itemsJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Item objects
      final List<Item> items = List<Item>.from(
        itemsJson.map((item) => Item.fromJson(item)),
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
      // Handle errors
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItemsByEan(
      {required String keyWord}) async {
    final Uri url = Uri.parse('http://localhost:3000/item');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> itemsJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Item objects
      final List<Item> items = List<Item>.from(
        itemsJson.map((item) => Item.fromJson(item)),
      );
      List<Item> eanItems = [];
      for (var item in items) {
        if (item.PLU_EAN.contains(keyWord)) {
          eanItems.add(item);
        }
      }

      return right(eanItems);
    } else {
      // Handle errors
      return left(CacheFailure());
    }
  }
}
