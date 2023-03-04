import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuantityDialog extends StatelessWidget {
  final quantity;
  final item;
  const QuantityDialog({Key key, @required this.quantity, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final controller = TextEditingController();
    controller.text = quantity.toString();
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Edit item quantity'),
          content: Container(
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
                  BlocProvider.of<CategoryBloc>(context)
                      .add(AddToOrder(item, num.parse(controller.text)));
                }
                if (state.gotitems == false) {
                  BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                }

                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).submit),
            )
          ],
        );
      },
    );
  }
}
