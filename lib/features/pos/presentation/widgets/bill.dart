import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/to_pay.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/table.dart';
import '../../domain/entities/item.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../screens/constants.dart';
import 'bill_buttons.dart';
import 'different_item_dialog.dart';
import 'num_pad.dart';
import 'ean_dialog.dart';
import 'package:provider/provider.dart';

import 'order_items.dart';

class Bill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return Container(
        height: height * 0.9,
        width: width * 0.3,
        padding: EdgeInsets.all(width * 0.02),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            //color: seconderyColor,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[const OrderItems(), BillButtons()]),
      );
    });
  }
}
