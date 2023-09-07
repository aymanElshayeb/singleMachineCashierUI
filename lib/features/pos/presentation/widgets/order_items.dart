import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import 'cart_item.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          height: height * 0.6,
          width: double.infinity,
          child: ListView.builder(
              itemCount: state.orderstate!.length,
              itemBuilder: (context, index) {
                return CartItem(
                  index: index,
                  state: state,
                  isDiscount: state.orderstate!.keys.elementAt(index).price > 0
                      ? false
                      : true,
                );
              }),
        );
      },
    );
  }
}
