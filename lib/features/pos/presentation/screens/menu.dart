import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../widgets/bill.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/menu_items.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return const Scaffold(
          body: Column(children: <Widget>[
        MainAppBar(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bill(),
              MenuItems(),
            ],
          ),
        )
      ]));
    });
  }
}
