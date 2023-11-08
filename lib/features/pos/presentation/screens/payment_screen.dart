import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/handle_printer_and_drawer.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/currency.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/number_pad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  final List<Item>? subOrder;
  final List<Item>? restOfOrder;
  final double totalPrice;
  const PaymentScreen(
      {super.key, this.subOrder, required this.totalPrice, this.restOfOrder});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double cash = 0;
  double inReturn = 0;
  bool isInteger = true;
  String? paymentMethod = 'Cash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                numberBar(
                    context: context,
                    number: widget.totalPrice,
                    title: AppLocalizations.of(context)!.total),
                numberBar(
                    context: context,
                    number: cash,
                    title: AppLocalizations.of(context)!.cash),
                numberBar(
                    context: context,
                    number: inReturn,
                    title: AppLocalizations.of(context)!.returnn),
                paymentMethodButton(),
                BlocListener<OrderBloc, OrderState>(
                  listener: (context, state) {
                    if (state is OrderUpdated) {
                      debugPrint('order added!!');
                      var snackBar2 = const SnackBar(
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        content: Text('Order is added successfully!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                      Navigator.of(context).pop();
                    }
                  },
                  child: paymentButton(
                      icon: Icons.done_all,
                      title: AppLocalizations.of(context)!.completepayment,
                      onPressed: () {
                        if (widget.totalPrice != 0) {
                          HandlePrinterAndDrawer.printOrderInvoice(
                              items: BlocProvider.of<OrderBloc>(context)
                                  .state
                                  .orderItems,
                              order: Order(
                                  totalPrice: widget.totalPrice,
                                  paymentMethod: paymentMethod == 'Cash'
                                      ? PaymentMethod.cash
                                      : PaymentMethod.card,
                                  dateTime: DateTime.now()));
                          BlocProvider.of<OrderBloc>(context).add(FinishOrder(
                              restOfOrderItems: widget.restOfOrder,
                              subOrder: widget.subOrder,
                              totalPrice: widget.totalPrice,
                              paymentMethod: paymentMethod == 'Cash'
                                  ? PaymentMethod.cash
                                  : PaymentMethod.card));
                        }
                      }),
                ),
                paymentButton(
                    icon: Icons.open_in_browser,
                    title: AppLocalizations.of(context)!.opendrawer,
                    onPressed: () {
                      HandlePrinterAndDrawer.openDrawer();
                    }),
              ],
            ),
            NumberPad(
              floatingPointMode: isInteger,
              onDecimalPointPressed: () {
                setState(() {
                  isInteger = !isInteger;
                });
              },
              onNumberPressed: (value) {
                String cashString = cash.toString();
                int indexOfDecimalPoint = cashString.indexOf('.');
                String integerPart =
                    cashString.substring(0, indexOfDecimalPoint);
                String decimalPart = cashString.substring(
                    indexOfDecimalPoint + 1, cashString.length);
                if (isInteger) {
                  integerPart += (value.toInt()).toString();
                } else {
                  decimalPart += (value.toInt()).toString();
                  decimalPart = decimalPart.substring(
                      decimalPart.length - 2, decimalPart.length);
                }

                setState(() {
                  cash = double.parse('$integerPart.$decimalPart');
                  if (cash >= widget.totalPrice) {
                    inReturn = cash - widget.totalPrice;
                  } else {
                    inReturn = 0;
                  }
                });
              },
              onBackspacePressed: () {
                String cashString = cash.toString();
                int indexOfDecimalPoint = cashString.indexOf('.');
                String integerPart =
                    cashString.substring(0, indexOfDecimalPoint);
                String decimalPart = cashString.substring(
                    indexOfDecimalPoint + 1, cashString.length);
                if (isInteger) {
                  integerPart =
                      integerPart.substring(0, integerPart.length - 1);
                } else {
                  decimalPart =
                      decimalPart.substring(0, decimalPart.length - 1);
                }

                setState(() {
                  cash = double.parse('$integerPart.$decimalPart');
                  if (cash >= widget.totalPrice) {
                    inReturn = cash - widget.totalPrice;
                  } else {
                    inReturn = 0;
                  }
                });
              },
            ),
            Currency(
              updateTotalCash: (value) {
                setState(() {
                  cash += value;
                  if (cash >= widget.totalPrice) {
                    inReturn = cash - widget.totalPrice;
                  } else {
                    inReturn = 0;
                  }
                });
              },
            ),
          ],
        ));
  }

  Widget paymentMethodButton() {
    return Row(
      children: [
        Radio(
          value: 'Cash',
          groupValue: paymentMethod,
          onChanged: (value) {
            setState(() {
              paymentMethod = value;
            });
          },
        ),
        Text(AppLocalizations.of(context)!.cash),
        Radio(
          value: 'CreditCard',
          groupValue: paymentMethod,
          onChanged: (value) {
            setState(() {
              paymentMethod = value;
            });
          },
        ),
        const Text('Credit Card'),
      ],
    );
  }

  Widget numberBar(
      {required double number,
      required String title,
      required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.230,
      height: MediaQuery.of(context).size.height * 0.077,
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
      child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 20,
                )),
          ],
        ),
        Text(
          number.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 40,
          ),
        )
      ])),
    );
  }

  Widget paymentButton(
      {required String title,
      required IconData icon,
      required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).dialogBackgroundColor),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.color),
              padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
              fixedSize: MaterialStatePropertyAll(Size(
                MediaQuery.of(context).size.width * 0.230,
                MediaQuery.of(context).size.height * 0.077,
              ))),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(title)),
    );
  }
}
