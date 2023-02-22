import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/item.dart';
import '../widgets/bill.dart';
import '../widgets/main_app_bar.dart';
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
              body: Column(children: <Widget>[
            const MainAppBar(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Bill(),
                  MenuItems(),
                ],
              ),
            )
          ]));
        }));
  }
}
