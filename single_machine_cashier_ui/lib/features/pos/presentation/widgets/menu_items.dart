import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/category_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/category_event.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/category_state.dart';
import 'package:single_machine_cashier_ui/injection_container.dart';
import '../../data/models/category_model.dart';
import '../pages/constants.dart';

class MenuItems extends StatelessWidget {
  MenuItems();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
        create: (context) => sl<CategoryBloc>()..add(InitEvent()),
        child: BlocBuilder<CategoryBloc, CategoryState>(

          builder: (context, state) {
            return GridView.builder(
              itemCount: state.categories.length, //should be length of the items list
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2),
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)]
                          .withOpacity(0.4),
                      shadowColor: primaryColor,
                      textStyle: TextStyle(
                        color: seconderyColor.withOpacity(1.0),
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: (() {
                      BlocProvider.of<CategoryBloc>(context)
                          .add(GetCategoryItems(index+1));
                    }),
                    child: Text(state.categories[index]),
                  ),
                );
              },
            );
          },
        ));
  }
}