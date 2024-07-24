import 'package:equatable/equatable.dart';
import 'package:firedart/firestore/models.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/discount.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';

enum PaymentMethod { cash, card }

class Order extends Equatable {
  final String id;
  final List<Item> items;
  final double taxPercentage;
  final List<Discount> orderDiscounts;
  double get discountAmount {
    double total = 0;
    for (var item in items) {
      total += item.totalDiscount;
    }
    return total;
  }

  double get amount {
    double total = 0;
    for (var item in items) {
      total += item.amount;
    }
    return total;
  }

  double get totalOrderDiscount {
    double total = 0;
    for (var discount in orderDiscounts) {
      total += discount.grossAmount;
    }
    return total;
  }

  double get netAmount {
    double total = 0;
    for (var item in items) {
      total += item.netAmount;
    }
    return total - totalOrderDiscount;
  }

  double get taxAmount => netAmount * (taxPercentage / 100);

  double get grossPrice => netAmount + taxAmount;

  final PaymentMethod paymentMethod;
  final DateTime issueDate;

  const Order({
    this.taxPercentage = 15.0,
    required this.paymentMethod,
    required this.issueDate,
    this.id = '0',
    required this.items,
    required this.orderDiscounts,
  });
List<Map<String, dynamic>> groupItemsByTax() {
  Map<double, List<Item>> groupedMap = {};

  // Grouping items by taxPercentage
  for (var item in items) {
    if (!groupedMap.containsKey(item.taxMap[1]['amount'])) {
      groupedMap[item.taxMap[1]['amount'][0]] = [];
    }
    groupedMap[item.taxMap[1]['amount']]!.add(item);
  }

  List<Map<String, dynamic>> result = [];

  // Constructing the result list
  groupedMap.forEach((taxPercentage, itemList) {
    double totalGrossPrice = itemList.map((item) => item.grossPrice).reduce((value, element) => value + element);
    double totalPriceWithoutVAT = itemList.map((item) => item.netAmount).reduce((value, element) => value + element);

    result.add({
      'percentage': (taxPercentage/100).toStringAsFixed(2),
      'incl_vat': totalGrossPrice.toStringAsFixed(2),
      'excl_vat': totalPriceWithoutVAT.toStringAsFixed(2),
      'vat':(totalGrossPrice-totalPriceWithoutVAT).toStringAsFixed(2)
    });
  });

  return result;
}

  @override
  List<Object?> get props => [id, paymentMethod, issueDate];
  static Order fromSnapshot(Document snap) {
    return Order(
        id: snap.id,
        items: snap['order']['items'] ?? [],
        orderDiscounts: snap['order']['orderDiscounts'] ?? [],
        paymentMethod: snap['order']['paymentMethod'] == 'cash'
            ? PaymentMethod.cash
            : PaymentMethod.card,
        issueDate: snap['order']['issueDate']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentMethod': paymentMethod.toString().split('.').last,
      'issueDate': issueDate.toIso8601String(),
      'items': items.map((e) => e.toMap()).toList(),
      'documentDiscounts': orderDiscounts.map((e) => e.toMap()).toList(),
      "amount": amount,
      "discountAmount": discountAmount,
      "documentDiscountAmount": totalOrderDiscount,
      "netAmount": netAmount,
      "taxAmount": taxAmount,
      "grossAmount": grossPrice,
    };
  }

  Map<String, dynamic> getInvoiceData() {
    return {
      "data": {
        "currency": 'EUR',
        "full_amount_incl_vat": grossPrice.toStringAsFixed(2),
        "full_amount_incl_vat_before_discount": (grossPrice - totalOrderDiscount).toStringAsFixed(2),
        "total_discount_value": totalOrderDiscount.toStringAsFixed(2),
        "date":DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "discounts": orderDiscounts
            .map((discount) =>
                {"name": "Discount", "discount_value": discount.grossAmount.toStringAsFixed(2)})
            .toList(),
        "payment_types": [
          {"amount": grossPrice.toStringAsFixed(2), "name": "CASH"}
        ],
        "vat_amounts":groupItemsByTax(),
        "lines": items
            .map(
              (e) => {
                "text": e.name,
                "vat_amounts": [
                  {
                    "percentage": (e.taxMap[1]['amount']/100).toStringAsFixed(2),
                    "incl_vat": e.grossPrice.toStringAsFixed(2)
                  }
                ],
                "item": {
                  "number": e.name,
                  "quantity": e.quantity.toStringAsFixed(2),
                  "price_per_unit": e.unitPrice.toStringAsFixed(2),
                  "full_amount": e.grossPrice.toStringAsFixed(2)
                },
                "discounts": e.discountPercentages != null
                    ? e.discountPercentages!
                        .map((discountPercentage) => {
                              "name": "Discount",
                              "discount_value":
                                  (discountPercentage * e.grossPrice).toStringAsFixed(2)
                            })
                        .toList()
                    : []
              },
            )
            .toList()
      }
    };
  }

  Map<String, dynamic> toMapGER() {
    return <String, dynamic>{
      "amounts_per_vat_rate": items
          .map((e) =>
              {"vat_rate": "NORMAL", "amount": e.grossPrice.toStringAsFixed(2)})
          .toList(),
      "amounts_per_payment_type": [
        {
          "payment_type":
              paymentMethod == PaymentMethod.cash ? 'CASH' : 'NON-CASH',
          "amount": grossPrice.toStringAsFixed(2)
        }
      ],
    };
  }
}
