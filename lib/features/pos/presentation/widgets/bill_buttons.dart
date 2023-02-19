import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../pages/constants.dart';
import '../pages/to_pay.dart';

class BillButtons extends StatelessWidget {
  final BuildContext context;
  BillButtons({Key key, @required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();
    TextEditingController customController2 = TextEditingController();
    TextEditingController customController3 = TextEditingController();
    List<Map<String, dynamic>> buttons = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Pay',
        'icon': const Icon(Icons.payment),
        'function': () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          return ToPay(
                            //orderstate: state.orderstate,
                            total: 50,
                          );
                        },
                      ))));
        }
      },
      <String, dynamic>{
        'title': 'Different item',
        'icon': const Icon(Icons.add_box),
        'function': () {
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
                            price: double.parse(customController2.text));
                        int quantity = int.parse(customController3.text);

                        Navigator.of(context).pop([item, quantity]);
                      },
                      child: Text("submit"),
                    )
                  ],
                );
              })).then((value) {
            BlocProvider.of<CategoryBloc>(context)
                .add(AddToOrder(value[0], value[1]));

            /*if (state.gotitems == false) {
                  BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                }*/
          });
        }
      },
      <String, dynamic>{
        'title': 'Fast pay',
        'icon': const Icon(Icons.payment),
        'function': () {}
      },
      <String, dynamic>{
        'title': 'Remove',
        'icon': const Icon(Icons.payment),
        'function': () {}
      },
      <String, dynamic>{
        'title': 'Pay',
        'icon': const Icon(Icons.payment),
        'function': () {}
      },
      <String, dynamic>{
        'title': 'Pay',
        'icon': const Icon(Icons.payment),
        'function': () {}
      },
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: 0.2 * height,
      child: GridView.builder(
        itemCount: 6, //should be length of the items list
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height),
            crossAxisCount: 3,
            crossAxisSpacing: width * 0.004,
            mainAxisSpacing: width * 0.004),
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                textStyle: TextStyle(
                  color: seconderyColor.withOpacity(1.0),
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: buttons[index]['function'],
              child: Text(buttons[index]['title']));
        },
      ),
    );
  }
}
