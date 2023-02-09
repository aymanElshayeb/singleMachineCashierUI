import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/item.dart';
import '../widgets/bill.dart';
import '../widgets/menu_items.dart';
import '../widgets/popup_menu.dart';
import '../widgets/table.dart';
import 'constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => sl<CategoryBloc>()..add(InitEvent()),
        child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          return Scaffold(
              body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                height: height * 0.1,
                decoration: BoxDecoration(
                    color: seconderyColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      padding: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.only(left: width * 0.08),
                        child: Text(
                          countTheTotal(state.orderstate),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          PopupMenu(),
                          menu_button(width, Icons.home, 'Home', state, () {
                            BlocProvider.of<CategoryBloc>(context)
                                .add(InitEvent());
                          }),
                          menu_button(width, Icons.power_settings_new, 'item1',
                              state, () {})
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: height * 0.9,
                        width: width * 0.3,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                            color: seconderyColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: BillPart()),
                    Container(
                        height: height * 0.9,
                        width: width * 0.66,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                            color: seconderyColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: MenuItems()),
                  ],
                ),
              )
            ]),
          ));
        }));
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

  String countTheTotal(Map<Item, int> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total.toString();
  }
}
