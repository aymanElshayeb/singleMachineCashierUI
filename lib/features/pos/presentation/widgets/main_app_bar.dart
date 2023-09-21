import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/categories/category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'Language_popup.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      height: height * 0.07,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: width * 0.02,
          ),
          Container(
            width: width * 0.082,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  return Text(
                    state.totalPrice.toString(),
                    style: TextStyle(
                        fontSize: width * 0.025, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: width * 0.435,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: Row(
              children: <Widget>[
                PopupMenu(),
                menuButton(Theme.of(context).primaryColor, width, height,
                    Icons.home, AppLocalizations.of(context)!.home, () {
                  BlocProvider.of<CategoryBloc>(context)
                      .add(FetchCategoriesEvent());
                }),
                menuButton(
                    Theme.of(context).primaryColor,
                    width,
                    height,
                    Icons.power_settings_new,
                    AppLocalizations.of(context)!.exit,
                    () {}),
                LangPopup(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String countTheTotal(Map<Item, num> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total.toString();
  }

  Container menuButton(Color color, double width, double height, IconData icon,
      String label, Function() onPressed) {
    return Container(
      height: height * 0.2,
      width: width * 0.1,
      margin: const EdgeInsets.all(5),
      child: ElevatedButton.icon(
        icon: Icon(icon), //icon data for elevated button
        label: Text(label), //label text
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          textStyle:
              TextStyle(fontSize: 0.011 * width, fontStyle: FontStyle.normal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
