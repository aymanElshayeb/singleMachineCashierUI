import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/invoice.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../domain/entities/customer.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/usecases/invoice_api.dart';
import '../../domain/usecases/pdf_api.dart';
import '../bloc/PaymentBloc/payment_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../widgets/currency.dart';
import '../widgets/num_pad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

class ToPay extends StatelessWidget {
  final Map<Item, num> order;
  final isOrder;
  const ToPay({Key? key, required this.order, required this.isOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    num total = countTheTotal(order);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController _myController = TextEditingController();
    final _log = Logger('ToPay');
    String selectedMethod = 'Cash';
    return BlocProvider(
      create: (context) => PaymentBloc()..add(getTotal(total: total)),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.paymentpage),
            ),
            body: Row(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(11.0))),
                    child: Column(children: [
                      numberBar(
                          Theme.of(context).primaryColor,
                          state.total,
                          AppLocalizations.of(context)!.total,
                          width * 0.230,
                          height * 0.077),
                      numberBar(
                          Theme.of(context).primaryColor,
                          state.cash,
                          AppLocalizations.of(context)!.cash,
                          width * 0.230,
                          height * 0.077),
                      numberBar(
                          Theme.of(context).primaryColor,
                          state.inreturn,
                          AppLocalizations.of(context)!.returnn,
                          width * 0.230,
                          height * 0.077),
                    ]),
                  ),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  Container(
                    width: width * 0.221,
                    height: height * 0.07,
                    margin: EdgeInsets.all(8.0),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: DropdownButton(
                      items: ["Cash", "Visa"]
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  "$e",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        BlocProvider.of<PaymentBloc>(context)
                            .add(UpdateMethod(method: val));

                        _log.fine(val);
                      },
                      value: state.selectedMethod,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  paymentButton(Theme.of(context).primaryColor, Icons.payment,
                      AppLocalizations.of(context)!.completepayment, () async {
                    if (state.cash >= state.total) {
                      if (state.total == 0) return;
                      BlocProvider.of<PaymentBloc>(context)
                          .add(getTotal(total: 0));
                      BlocProvider.of<CategoryBloc>(context)
                          .add(FinishOrder(isOrder));
                      final currentBloc = context.read<CategoryBloc>();
                      Map<Item, num> order;

                      if (isOrder) {
                        BlocProvider.of<CartBloc>(context).add(
                            SaveOrder(items: currentBloc.state.orderstate!));
                        order = currentBloc.state.orderstate!;
                      } else {
                        BlocProvider.of<CartBloc>(context).add(
                            SaveOrder(items: currentBloc.state.subOrderState));
                        order = currentBloc.state.subOrderState;
                      }
                      BlocProvider.of<PaymentBloc>(context).add(NewPayment());
                      List<Item> listt = order.keys.toList();
                      print(json.encode(listt));
                      List<InvoiceItem> invoiceItems = [];
                      order.forEach((key, value) => invoiceItems.add(
                          InvoiceItem(
                              description: key.name,
                              date: DateTime.now(),
                              quantity: value,
                              unitPrice: key.price)));
                      final date = DateTime.now();
                      final dueDate = date.add(Duration(days: 7));
                      final invoice = Invoice(
                          info: InvoiceInfo(
                              dueDate: dueDate,
                              date: date,
                              description: 'My description...',
                              number: '${DateTime.now().year}-9999'),
                          supplier: const Supplier(
                              name: 'Sarah Field',
                              address: 'Sarah Street 9, Beijing, China',
                              paymentInfo: 'https://paypal.me/sarahfieldzz'),
                          customer: const Customer(
                            name: 'Apple Inc.',
                            address: 'Apple Street, Cupertino, CA 95014',
                          ),
                          items: invoiceItems);
                      final pdfFile = await PdfInvoiceApi.generate(invoice);

                      PdfApi.openFile(pdfFile);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Not Enough Cash!")));
                    }
                  }, width * 0.221, height * 0.07),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  paymentButton(
                      Theme.of(context).primaryColor,
                      Icons.monetization_on,
                      AppLocalizations.of(context)!.opendrawer,
                      () {},
                      width * 0.221,
                      height * 0.07),
                ]),
                SizedBox(
                  width: width * 0.02,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Container(
                      width: width * 0.2,
                      height: height * 0.45,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(11.0))),
                      child: NumPad(
                        buttonSize: width * 0.04,

                        buttonColor: Theme.of(context).canvasColor,

                        iconColor: Theme.of(context).primaryColorLight,
                        controller: _myController,
                        delete: () {
                          BlocProvider.of<PaymentBloc>(context)
                              .add(DeleteFromCash());
                          BlocProvider.of<PaymentBloc>(context)
                              .add(AddToCash(money: 0));
                        },
                        // do something with the input numbers
                        onSubmit: () {},
                      )),
                ),
                const Currency(),
              ],
            ),
          );
        },
      ),
    );
  }

  Container numberBar(
      Color color, num number, String title, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 20,
                )),
          ],
        ),
        Container(
            child: number == 0
                ? Text("")
                : Text(
                    number.toString(),
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ))
      ])),
    );
  }

  Container paymentButton(Color color, IconData icon, String title,
      Function() function, double width, double height) {
    return Container(
        width: width,
        height: height,
        child: MaterialButton(
          color: color,
          onPressed: function,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              icon,
              size: 24,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(title)
          ]),
        ));
  }

  double countTheTotal(Map<Item, num> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total;
  }
}
