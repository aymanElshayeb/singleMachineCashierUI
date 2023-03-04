import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

import '../../domain/entities/item.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DifferentItem extends StatelessWidget {
  const DifferentItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();
    TextEditingController EanController = TextEditingController();
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context).enteranitem),
        content: Container(
          height: height * 0.25,
          child: Column(children: [
            Container(
              width: width * 0.19,
              height: height * 0.08,
              child: TextField(
                controller: customController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).name,
                  suffixIcon: Icon(
                    Icons.fastfood,
                    size: width * 0.014,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Keyboard(
                        controller: customController,
                        number: false,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: width * 0.19,
              height: height * 0.08,
              child: TextField(
                controller: customController2,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).price,
                  suffixIcon: Icon(
                    Icons.price_change,
                    size: width * 0.014,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Keyboard(
                        controller: customController2,
                        number: true,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: width * 0.19,
              height: height * 0.08,
              child: TextField(
                controller: customController3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).quantity,
                  suffixIcon: Icon(
                    Icons.add,
                    size: width * 0.014,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Keyboard(
                        controller: customController3,
                        number: true,
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Item item = Item(
                  name: customController.text,
                  price: double.parse(customController2.text));
              int quantity = int.parse(customController3.text);
              BlocProvider.of<CategoryBloc>(context)
                  .add(AddToOrder(item, quantity));
              if (state.gotitems == false) {
                BlocProvider.of<CategoryBloc>(context).add(InitEvent());
              }
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).submit),
          )
        ],
      );
    });
  }
}
