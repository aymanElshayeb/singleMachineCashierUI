import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemDiscountDialog extends StatelessWidget {
  final Item item;
  final num quantity;
  const ItemDiscountDialog(
      {Key key, @required this.item, @required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPercent = true;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title:
              Text('${AppLocalizations.of(context).discount} - ${item.name}'),
          content: Container(
            width: width * 0.19,
            height: height * 0.08,
            child: TextField(
              controller: customController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).discount,
                suffixIcon: Icon(
                  Icons.discount,
                  size: width * 0.014,
                ),
              ),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                double discount = double.parse(customController.text);
                double total = countTheTotal(state.orderstate);
                if (total - discount >= 0 &&
                    discount <= (item.price * quantity)) {
                  Item temp_item =
                      Item(name: 'Discount - ${item.name}', price: -discount);
                  BlocProvider.of<CategoryBloc>(context)
                      .add(AddToOrder(temp_item, 1));
                  if (state.gotitems == false) {
                    BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                  }

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Enter sufficient credentials!")));
                }
              },
              child: Text(AppLocalizations.of(context).submit),
            )
          ],
        );
      },
    );
  }

  double countTheTotal(Map<Item, num> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total;
  }
}
