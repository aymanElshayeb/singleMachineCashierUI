import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuantityDialog extends StatelessWidget {
  final Item item;
  const QuantityDialog({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final controller = TextEditingController();
    controller.text = item.quantity.toString();
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editquantity),
      content: SizedBox(
          height: height * 0.071,
          child: Column(
            children: [
              TextField(
                controller: controller,
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Keyboard(
                        controller: controller,
                        number: true,
                      );
                    },
                  );
                },
              ),
            ],
          )),
      actions: [
        MaterialButton(
          onPressed: () {
            if (num.parse(controller.text) > 0) {
              BlocProvider.of<OrderBloc>(context).add(AddItemToOrder(
                  item: item, quantity: double.parse(controller.text)));
            }

            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.submit),
        )
      ],
    );
  }
}
