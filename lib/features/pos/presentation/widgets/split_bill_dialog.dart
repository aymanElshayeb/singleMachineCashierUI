import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../screens/to_pay.dart';

class SplitBill extends StatelessWidget {
  const SplitBill({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Split bill'),
          content: Container(
            width: width * 0.65,
            height: height * 0.6,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  order(width * 0.3, height * 0.6, context),
                  subOrder(width * 0.3, height * 0.6, context),
                ]),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                final currentBloc = context.read<CategoryBloc>();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => BlocProvider.value(
                              value: currentBloc,
                              child: ToPay(
                                order: currentBloc.state.subOrderState,
                                isOrder: false,
                              ),
                            ))));
                //Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).pay),
            )
          ],
        );
      },
    );
  }

  BlocBuilder<CategoryBloc, CategoryState> order(
      double width, double height, BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              //color: seconderyColor,
              borderRadius: BorderRadius.circular(15)),
          child: state.orderstate.length > 0
              ? ListView.builder(
                  itemCount: state.orderstate.length,
                  itemBuilder: (cc, index) {
                    return Card(
                      child: ListTile(
                        title:
                            Text(state.orderstate.keys.elementAt(index).name),
                        subtitle: Text(state.orderstate.keys
                            .elementAt(index)
                            .price
                            .toString()),
                        trailing: Column(children: [
                          Text(state.orderstate.values
                              .elementAt(index)
                              .toString()),
                          InkWell(
                            child: Icon(Icons.drive_file_move_outlined),
                            onTap: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                  AddToSubOrder(
                                      state.orderstate.keys.elementAt(index),
                                      1));
                              if (state.orderstate.values.elementAt(index) >
                                  1) {
                                BlocProvider.of<CategoryBloc>(context).add(
                                    SubtractFromOrder(state.orderstate.keys
                                        .elementAt(index)));
                              } else {
                                BlocProvider.of<CategoryBloc>(context).add(
                                    DeleteFromOrder(state.orderstate.keys
                                        .elementAt(index)));
                              }
                            },
                          )
                        ]),
                        onTap: () {
                          BlocProvider.of<CategoryBloc>(context).add(
                              AddToSubOrder(
                                  state.orderstate.keys.elementAt(index),
                                  state.orderstate.values.elementAt(index)));
                          BlocProvider.of<CategoryBloc>(context).add(
                              DeleteFromOrder(
                                  state.orderstate.keys.elementAt(index)));
                        },
                      ),
                    );
                  })
              : Container(
                  child: Center(child: Text('Order')),
                ),
        );
      },
    );
  }

  BlocBuilder<CategoryBloc, CategoryState> subOrder(
      double width, double height, BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              //color: seconderyColor,
              borderRadius: BorderRadius.circular(15)),
          child: state.subOrderState.length > 0
              ? ListView.builder(
                  itemCount: state.subOrderState.length,
                  itemBuilder: (cc, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            state.subOrderState.keys.elementAt(index).name),
                        subtitle: Text(state.subOrderState.keys
                            .elementAt(index)
                            .price
                            .toString()),
                        trailing: Column(children: [
                          Text(state.subOrderState.values
                              .elementAt(index)
                              .toString()),
                          InkWell(
                            child: Icon(Icons.drive_file_move_rtl_outlined),
                            onTap: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                  AddToOrder(
                                      state.subOrderState.keys.elementAt(index),
                                      1));
                              if (state.subOrderState.values.elementAt(index) >
                                  1) {
                                BlocProvider.of<CategoryBloc>(context).add(
                                    SubtractFromSubOrder(state
                                        .subOrderState.keys
                                        .elementAt(index)));
                              } else {
                                BlocProvider.of<CategoryBloc>(context).add(
                                    DeleteFromSubOrder(state.subOrderState.keys
                                        .elementAt(index)));
                              }
                            },
                          )
                        ]),
                        onTap: () {
                          BlocProvider.of<CategoryBloc>(context).add(AddToOrder(
                              state.subOrderState.keys.elementAt(index),
                              state.subOrderState.values.elementAt(index)));
                          BlocProvider.of<CategoryBloc>(context).add(
                              DeleteFromSubOrder(
                                  state.subOrderState.keys.elementAt(index)));
                        },
                      ),
                    );
                  })
              : Container(child: Center(child: Text('Sub-order'))),
        );
      },
    );
  }
}
