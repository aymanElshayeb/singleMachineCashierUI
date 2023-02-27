import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/quantity_dialog.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final int index;
  final CategoryState state;

  const CartItem({Key key, @required this.index, @required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.15,
      child: Card(
        semanticContainer: true,
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity(vertical: 4),
          title: Text(
            state.orderstate.keys.elementAt(index).name,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: height * 0.022),
          ),
          subtitle: Text(
              state.orderstate.keys.elementAt(index).price.toString(),
              style: TextStyle(fontSize: height * 0.022)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Icon(Icons.delete, size: height * 0.029),
                onTap: (() {
                  BlocProvider.of<CategoryBloc>(context).add(
                      DeleteFromOrder(state.orderstate.keys.elementAt(index)));
                }),
              ),
              Text(
                  (state.orderstate.keys.elementAt(index).price *
                          state.orderstate.values.elementAt(index))
                      .toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: height * 0.019)),
              Container(
                width: width * 0.06,
                height: height * 0.035,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Icon(Icons.remove),
                        onTap: () {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(SubtractFromOrder(
                            state.orderstate.keys.elementAt(index),
                          ));
                        },
                      ),
                      InkWell(
                        child: Text(
                            '${state.orderstate.values.elementAt(index).toString()}'),
                        onTap: (() {
                          final currentBloc = context.read<CategoryBloc>();
                          showDialog(
                              context: context,
                              builder: (((cc) {
                                return BlocProvider.value(
                                  value: currentBloc,
                                  child: QuantityDialog(
                                      quantity: state.orderstate.values
                                          .elementAt(index),
                                      item: state.orderstate.keys
                                          .elementAt(index)),
                                );
                              })));
                        }),
                      ),
                      InkWell(
                        child: Icon(Icons.add),
                        onTap: () {
                          BlocProvider.of<CategoryBloc>(context).add(
                              UpdateOrderEvent(
                                  state.orderstate.keys.elementAt(index),
                                  state.categoryitems));
                        },
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
