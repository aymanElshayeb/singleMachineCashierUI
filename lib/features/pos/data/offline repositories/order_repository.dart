import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';
import 'package:http/http.dart' as http;
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;

class OfflineOrderRepository implements OrderRepository {
  @override
  Future<Either<Failure, void>> saveOrder(
      double orderPrice, PaymentMethod paymentMethod) async {
    entity.Order order = entity.Order(
        totalPrice: orderPrice,
        paymentMethod: paymentMethod,
        dateTime: DateTime.now());
    try {
      const storage = FlutterSecureStorage();
      final String? jwtToken = await storage.read(key: 'token');
      final http.Response response = await http.post(
        Uri.parse('http://localhost:3003/order'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(order.toMap()),
      );

      if (response.statusCode == 200) {
        // Successful POST request
        debugPrint('Response: ${response.body}');
        return right(null);
      } else {
        // Handle errors
        debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
        return left(CacheFailure());
      }
    } catch (e) {
      return left(CacheFailure());
    }
  }
}
