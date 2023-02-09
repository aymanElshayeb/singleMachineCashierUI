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

class BillPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int length = 0;
    Map<Item, int> order = {};
    BuildContext cc;
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();

    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      cc = context;
      return SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                Widget>[
          Container(
            height: height * 0.6,
            width: double.infinity,
            child: ListView.builder(
                itemCount: state.orderstate.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(state.orderstate.keys.elementAt(index).name),
                      subtitle: Text(
                          state.orderstate.values.elementAt(index).toString()),
                      trailing: Text(state.orderstate.keys
                          .elementAt(index)
                          .price
                          .toString()),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            height: 0.2 * height,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    option_Button(Icon(Icons.payment), 'Pay', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ToPay(
                                    total: countTheTotal(state.orderstate),
                                  ))));
                    }),
                    option_Button(Icon(Icons.payments), ' Fast Pay', () {}),
                    option_Button(Icon(Icons.add_box), 'Different Item', () {
                      /*popUpDialog(context).then((value) {
                        BlocProvider.of<CategoryBloc>(context)
                            .add(AddToOrder(value.first, value.second));
                        
                      });*/
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: Text('Enter an item'),
                              content: Column(children: [
                                Text('name'),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  controller: customController,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('price'),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  controller: customController2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Quantity'),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  controller: customController3,
                                ),
                              ]),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Item item = Item(
                                        name: customController.text,
                                        price: double.parse(
                                            customController2.text));
                                    int quantity =
                                        int.parse(customController3.text);

                                    Navigator.of(context).pop([item, quantity]);
                                  },
                                  child: Text("submit"),
                                )
                              ],
                            );
                          })).then((value) {
                        BlocProvider.of<CategoryBloc>(context)
                            .add(AddToOrder(value[0], value[1]));
                        if (state.gotitems == false) {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(InitEvent());
                        }
                      });
                    }),
                  ],
                ),
                Row(
                  children: <Widget>[
                    option_Button(Icon(Icons.delete), 'Remove', () {}),
                    option_Button(Icon(Icons.search), ' Bar-Code', () {}),
                    option_Button(Icon(Icons.cancel), 'Cancel', () {}),
                  ],
                )
              ],
            ),
          )
        ]),
      );
    });
  }

  Expanded option_Button(Icon icon, String label, Function function) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton.icon(
          onPressed: function,
          icon: icon,
          label: Text(label),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.grey.withOpacity(0.6)),
            shadowColor: MaterialStateProperty.all(Colors.grey),
            elevation: MaterialStateProperty.all(5),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
            //padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // overlayColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
    );
  }

  double countTheTotal(Map<Item, int> order) {
    double total = 0;
    for (int i = 0; i < order.length; i++) {
      total += order.keys.elementAt(i).price * order.values.elementAt(i);
    }
    return total;
  }

  Future<Pair<Item, int>> popUpDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter an item'),
            content: Column(children: [
              Text('name:'),
              TextField(
                controller: customController,
              ),
              Text('price:'),
              TextField(
                controller: customController2,
              ),
              Text('Quantity:'),
              TextField(
                controller: customController3,
              ),
            ]),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5,
                  textColor: Colors.red,
                  child: Text('Submit'),
                  onPressed: (() {
                    Item item = Item(
                        name: customController.text,
                        price: double.parse(customController2.text));
                    int quantity = int.parse(customController3.text);
                    Navigator.of(context).pop({item: quantity});
                  }))
            ],
          );
        });
  }
}
