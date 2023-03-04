import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

import '../../domain/entities/item.dart';
import '../bloc/Locale/locale_bloc_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import 'package:provider/provider.dart';

class DiscountPopup extends StatefulWidget {
  @override
  State<DiscountPopup> createState() => _DiscountPopupState();
}

class _DiscountPopupState extends State<DiscountPopup> {
  List<String> listitems = [
    "Percentage",
    "Value",
  ];
  String selectval = "Value";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController customController = TextEditingController();
    num index = 0;
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return AlertDialog(
        title: Text('Discount'),
        content: Container(
            width: width * 0.19,
            height: height * 0.15,
            child: Column(
              children: [
                Container(
                  height: height * 0.05,
                  width: width * 0.1,
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  alignment: Alignment.topCenter,
                  child: DropdownButton(
                    value: selectval,
                    onChanged: (value) {
                      if (value == 'Value') {
                      } else {
                        print(selectval);
                      }

                      setState(() {
                        selectval = value.toString();
                      });
                    },
                    items: listitems.map((itemone) {
                      return DropdownMenuItem(
                          value: itemone,
                          child: Text(
                            itemone,
                            style: TextStyle(fontSize: width * 0.01),
                          ));
                    }).toList(),
                  ),
                ),
                TextField(
                  controller: customController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).discount,
                    suffixIcon: Icon(
                      Icons.discount,
                      size: width * 0.014,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Keyboard(
                          controller: customController,
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
              double discount = double.parse(customController.text);
              final currentBloc = context.read<CategoryBloc>();

              double total = countTheTotal(currentBloc.state.orderstate);
              if (selectval == 'Percentage') {
                if (total - discount > 0 && discount <= 100) {
                  Item item = Item(
                      name: 'Discount', price: -((discount / 100) * total));

                  BlocProvider.of<CategoryBloc>(context)
                      .add(AddToOrder(item, 1));
                  if (currentBloc.state.gotitems == false) {
                    BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                  }

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Enter sufficient credentials!")));
                }
              } else {
                if (total - discount > 0) {
                  Item item = Item(name: 'Discount', price: -discount);

                  BlocProvider.of<CategoryBloc>(context)
                      .add(AddToOrder(item, 1));
                  if (currentBloc.state.gotitems == false) {
                    BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                  }

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Enter sufficient credentials!")));
                }
              }
            },
            child: Text(AppLocalizations.of(context).submit),
          )
        ],
      );
    });
  }

  double countTheTotal(Map<Item, num> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total;
  }
}
