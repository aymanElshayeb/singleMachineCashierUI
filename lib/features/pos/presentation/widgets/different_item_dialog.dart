import 'package:single_machine_cashier_ui/components/global_textfield.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DifferentItem extends StatelessWidget {
  const DifferentItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.enteranitem),
      content: SizedBox(
        height: height * 0.25,
        child: Column(children: [
          GlobalTextField(
            customController: customController,
            iconData: Icons.fastfood,
            labelText: AppLocalizations.of(context)!.name,
            isNumber: false,
          ),
          GlobalTextField(
            customController: customController2,
            iconData: Icons.price_change,
            labelText: AppLocalizations.of(context)!.price,
            isNumber: true,
          ),
          GlobalTextField(
            customController: customController3,
            iconData: Icons.add,
            labelText: AppLocalizations.of(context)!.quantity,
            isNumber: true,
          ),
        ]),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Item customItem = Item.custom(
                name: customController.text,
                price: double.parse(customController2.text),
                quantity: double.parse(customController3.text));

            BlocProvider.of<OrderBloc>(context)
                .add(AddItemToOrder(item: customItem));
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.submit),
        )
      ],
    );
  }
}
