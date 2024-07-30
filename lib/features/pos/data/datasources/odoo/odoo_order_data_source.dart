import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
import 'package:http/http.dart' as http;

class OdooOrderDataSource implements OrderDataSource {
  final String odooUrl = 'http://localhost:8069';
  @override
  Future<Either<Failure, String>> createInvoice(entity.Order order) async {
    final Uri url = Uri.parse('$odooUrl/web/dataset/call_kw');
    const storage = FlutterSecureStorage();
    final String? sessionId = await storage.read(key: 'sessionId');
    final String? orderIdString = await storage.read(key: 'orderId');
    if (sessionId == null) {
      return left(AuthenticationFailure());
    }
    if (orderIdString == null) {
      return left(CacheFailure());
    }
    int orderId = int.parse(orderIdString);
    final int invoiceId = await generateInvoice(
        jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "model": "pos.order",
            "method": "action_pos_order_invoice",
            "args": [orderId],
            "kwargs": {}
          },
          "id": 5
        }),
        sessionId,
        url);
    if (invoiceId != -1) {
      String invoicePdf = await getInvoicePdf(sessionId,
          Uri.parse('$odooUrl/report/pdf/account.report_invoice/$invoiceId'));
      return right(invoicePdf);
    }
    return left(CacheFailure());
  }

  @override
  Future<Either<Failure, void>> saveOrder(entity.Order order) async {
    final Uri url = Uri.parse('$odooUrl/web/dataset/call_kw');
    const storage = FlutterSecureStorage();
    final String? sessionId = await storage.read(key: 'sessionId');
    if (sessionId == null) {
      return left(AuthenticationFailure());
    }
    final orderId = await createOrder(
        jsonEncode({
          "jsonrpc": "2.0",
          "method": "call",
          "params": {
            "model": "pos.order",
            "method": "create",
            "args": [
              {
                "session_id": 4,
                "partner_id": 1,
                "amount_tax": order.taxAmount,
                "amount_total": order.grossPrice,
                "amount_paid": order.grossPrice,
                "amount_return": 0,
                "pos_reference": "POS/2024/${order.id}",
                "name": "shop order/${order.id}",
                "lines": order.items
                    .map(
                      (item) => [
                        0,
                        0,
                        {
                          "product_id": item.id,
                          "qty": item.quantity,
                          "price_unit": item.unitPrice,
                          "price_subtotal": item.netAmount,
                          "price_subtotal_incl": item.grossPrice,
                          "tax_ids": [
                            [6, 0, item.taxIds]
                          ],
                          "discount": calculateEffectiveDiscount(
                                  discountPercentages:
                                      item.discountPercentages) *
                              100
                        }
                      ],
                    )
                    .toList()
              }
            ],
            "kwargs": {}
          },
          "id": 3
        }),
        sessionId,
        url);
    print(orderId);
    bool isOrderStatusPaid = false;
    if (orderId != -1) {
      await storage.write(key: 'orderId', value: orderId.toString());
      isOrderStatusPaid = await changeOrderStatusToPaid(
          jsonEncode({
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              "model": "pos.order",
              "method": "action_pos_order_paid",
              "args": [orderId],
              "kwargs": {}
            },
            "id": 4
          }),
          sessionId,
          url);
    }

    return isOrderStatusPaid ? right(null) : left(CacheFailure());
  }

  Future<int> createOrder(
      String encodedOrderBody, String sessionId, Uri url) async {
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: encodedOrderBody);
    if (response.statusCode == 200) {
      final int orderId = jsonDecode(response.body)['result'];
      return orderId;
    }

    return -1;
  }

  double calculateEffectiveDiscount({List<double>? discountPercentages}) {
    double effectiveDiscount = 1.0;
    if (discountPercentages == null) {
      return 0;
    }

    for (double discount in discountPercentages) {
      effectiveDiscount *= (1 - discount / 100);
    }

    return (1 - effectiveDiscount) * 100;
  }

  Future<bool> changeOrderStatusToPaid(
      String encodedOrderBody, String sessionId, Uri url) async {
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: encodedOrderBody);
    if (response.statusCode == 200) {
      final bool result = jsonDecode(response.body)['result'];
      return result;
    }

    return false;
  }

  Future<int> generateInvoice(
      String encodedOrderBody, String sessionId, Uri url) async {
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId'
        },
        body: encodedOrderBody);
    if (response.statusCode == 200) {
      final int invoiceId = jsonDecode(response.body)['result']['res_id'];
      return invoiceId;
    }

    return -1;
  }

  Future<String> getInvoicePdf(String sessionId, Uri url) async {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=$sessionId'
    });
    if (response.statusCode == 200) {
      final encodedPdf = base64Encode(response.bodyBytes);
      return encodedPdf;
    }

    return '';
  }
}
