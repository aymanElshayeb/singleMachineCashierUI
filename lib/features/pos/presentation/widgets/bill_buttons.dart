import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../screens/constants.dart';
import '../screens/to_pay.dart';
import 'package:provider/provider.dart';

import 'different_item_dialog.dart';
import 'discount_dialog.dart';
import 'ean_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillButtons extends StatelessWidget {
  final BuildContext context;
  BillButtons({Key key, @required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();
    List<Map<String, dynamic>> buttons = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': AppLocalizations.of(context).pay,
        'icon': const Icon(Icons.payment),
        'function': () {
          final currentBloc = context.read<CategoryBloc>();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ToPay(
                        total: countTheTotal(currentBloc.state.orderstate),
                      ))));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context).fastpay,
        'icon': const Icon(Icons.attach_money_rounded),
        'function': () {}
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context).differentitem,
        'icon': const Icon(Icons.add_box),
        'function': () {
          final currentBloc = context.read<CategoryBloc>();
          showDialog(
              context: context,
              builder: (((cc) {
                return BlocProvider.value(
                  value: currentBloc,
                  child: DifferentItem(),
                );
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context).discount,
        'icon': const Icon(Icons.discount),
        'function': () {
          final currentBloc = context.read<CategoryBloc>();
          showDialog(
              context: context,
              builder: (((cc) {
                return BlocProvider.value(
                  value: currentBloc,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      return DiscountDialog(order: state.orderstate);
                    },
                  ),
                );
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context).eansearch,
        'icon': const Icon(Icons.manage_search_sharp),
        'function': () {
          final currentBloc = context.read<CategoryBloc>();
          showDialog(
              context: context,
              builder: (((cc) {
                return BlocProvider.value(
                  value: currentBloc,
                  child: CustomDialog(),
                );
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context).cancel,
        'icon': const Icon(Icons.cancel),
        'function': () {}
      },
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: 0.2 * height,
      child: GridView.builder(
        itemCount: buttons.length, //should be length of the items list
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height),
            crossAxisCount: 3,
            crossAxisSpacing: width * 0.004,
            mainAxisSpacing: width * 0.004),
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                //backgroundColor: Colors.grey,
                backgroundColor: Theme.of(context).primaryColor,

                textStyle: TextStyle(
                  color: seconderyColor.withOpacity(1.0),
                  fontSize: height * 0.017,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: buttons[index]['function'],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttons[index]['icon'],
                  Text(
                    buttons[index]['title'],
                  ),
                ],
              ));
        },
      ),
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
