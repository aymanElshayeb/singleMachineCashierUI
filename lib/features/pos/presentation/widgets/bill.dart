import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/pages/to_pay.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/listviewtable.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/table.dart';
import '../../domain/entities/item.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import 'bill_buttons.dart';
import 'different_item_dialog.dart';
import 'num_pad.dart';
import 'ean_dialog.dart';
import 'package:provider/provider.dart';

import 'order_items.dart';

class BillPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[const OrderItems(), BillButtons()]);
    });
  }
}
