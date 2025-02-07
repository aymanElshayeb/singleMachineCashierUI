import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
import 'package:http/http.dart' as http;

class NodeOrderDataSource implements OrderDataSource {
  final invoicingEndpoint = const String.fromEnvironment('INVOICING_ENDPOINT');
  final countryCode = const String.fromEnvironment('COUNTRY_CODE');
  final clientId = const String.fromEnvironment('TSS_CLIENT');

  @override
  Future<Either<Failure, String>> createInvoice(entity.Order order) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$invoicingEndpoint/$countryCode'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(countryCode == 'ksa'
            ? order.toMap()
            : {
                'items': order.toMapGER(),
                'client_id': clientId,
                'orderData': order.getInvoiceData()
              }),
      );

      if (response.statusCode == 200) {
        // Successful POST request
        return right(response.body);
      } else {
        // Handle errors
        debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
        final responseMap = jsonDecode(response.body);
        if (responseMap['message'] == 'Unauthorized: Invalid token') {
          return left(AuthenticationFailure());
        }
        return left(CacheFailure());
      }
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveOrder(entity.Order order) async {
    try {
      const storage = FlutterSecureStorage();
      final String? jwtToken = await storage.read(key: 'token');
      final http.Response response = await http.post(
        Uri.parse('http://localhost:3003/order'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'order': jsonEncode(order.toMap())}),
      );

      if (response.statusCode == 200) {
        // Successful POST request
        debugPrint('Response: ${response.body}');
        return right(null);
      } else {
        // Handle errors
        debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
        final responseMap = jsonDecode(response.body);
        if (responseMap['message'] == 'Unauthorized: Invalid token') {
          return left(AuthenticationFailure());
        }
        return left(CacheFailure());
      }
    } catch (e) {
      return left(CacheFailure());
    }
  }
}
