import 'package:flutter/material.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/bill_buttons.dart';
import 'order_items.dart';

class Bill extends StatelessWidget {
  const Bill({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.9,
      width: width * 0.3,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const OrderItems(),
            BillButtons(
              context: context,
            )
          ]),
    );
  }
}
