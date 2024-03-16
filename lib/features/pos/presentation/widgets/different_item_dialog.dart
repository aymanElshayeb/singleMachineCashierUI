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
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController taxController = TextEditingController();
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.enteranitem),
      content: SizedBox(
        height: height * 0.32,
        child: Column(children: [
          GlobalTextField(
            customController: nameController,
            iconData: Icons.fastfood,
            labelText: AppLocalizations.of(context)!.name,
            isNumber: false,
          ),
          GlobalTextField(
            customController: priceController,
            iconData: Icons.price_change,
            labelText: AppLocalizations.of(context)!.price,
            isNumber: true,
          ),
          GlobalTextField(
            customController: taxController,
            iconData: Icons.price_change,
            labelText: 'tax percentage',
            isNumber: true,
          ),
          GlobalTextField(
            customController: quantityController,
            iconData: Icons.add,
            labelText: AppLocalizations.of(context)!.quantity,
            isNumber: true,
          ),
        ]),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            double unitPrice = double.parse(priceController.text);
            double quantity = double.parse(quantityController.text);
            double taxPercentage =
                taxController.text == '' ? 0 : double.parse(taxController.text);
            Item customItem = Item.custom(
                taxPercentage: taxPercentage,
                name: nameController.text,
                price: unitPrice,
                quantity: quantity,discountPercentages: []);

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
