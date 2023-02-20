import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/constants.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/popup_menu.dart';

import '../../domain/entities/item.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(5),
          width: double.infinity,
          height: height * 0.07,
          decoration: BoxDecoration(
              color: seconderyColor, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width * 0.02,
              ),
              Container(
                width: width * 0.082,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(
                    countTheTotal(state.orderstate),
                    style: TextStyle(
                        fontSize: width * 0.025, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.6,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.02),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PopupMenu(),
                    menu_button(width, Icons.home,
                        AppLocalizations.of(context).home, state, () {
                      BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                    }),
                    menu_button(width, Icons.power_settings_new,
                        AppLocalizations.of(context).exit, state, () {})
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String countTheTotal(Map<Item, int> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total.toString();
  }

  Container menu_button(double width, IconData icon, String label,
      CategoryState state, Function function) {
    return Container(
      height: 35,
      width: 100,
      margin: EdgeInsets.all(5),
      //padding: EdgeInsets.all(width * 0.01),
      child: ElevatedButton.icon(
        icon: Icon(icon), //icon data for elevated button
        label: Text(label), //label text
        style: ElevatedButton.styleFrom(
          primary: Colors.grey.withOpacity(0.6),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontStyle: FontStyle.normal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: ((function)),
      ),
    );
  }
}
