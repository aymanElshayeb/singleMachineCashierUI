import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          height: height * 0.6,
          width: double.infinity,
          child: ListView.builder(
              itemCount: state.orderstate.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.orderstate.keys.elementAt(index).name),
                    subtitle: Text('×' +
                        state.orderstate.values.elementAt(index).toString()),
                    trailing: Text(
                        state.orderstate.keys.elementAt(index).price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                );
              }),
        );
      },
    );
  }
}
