import 'package:single_machine_cashier_ui/features/pos/domain/entities/customer.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final num quantity;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.unitPrice,
  });
}
