import 'package:single_machine_cashier_ui/features/pos/domain/entities/customer.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/invoice.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/supplier.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/invoice_api.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class HandlePrinterAndDrawer {
  static Future<void> printOrderInvoice(
      {List<Item>? items, Order? order}) async {
    PdfInvoiceApi.generate(Invoice(
        info: InvoiceInfo(
            description: 'order items',
            number: order!.id,
            date: DateTime.now(),
            dueDate: DateTime.now().add(const Duration(days: 14))),
        supplier: Supplier(
            name: 'suplier name',
            address: 'suplier address',
            paymentInfo: order.paymentMethod.name),
        customer:
            const Customer(name: 'customer name', address: 'customer address'),
        items: items!
            .map((item) => InvoiceItem(
                description: item.name,
                date: DateTime.now(),
                quantity: item.quantity,
                unitPrice: item.price))
            .toList()));
  }

  static Future<void> openDrawer() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Empty invoice'),
          ); // Center
        }));
    PdfApi.saveDocument(name: 'empty', pdf: doc);
  }
  
}
