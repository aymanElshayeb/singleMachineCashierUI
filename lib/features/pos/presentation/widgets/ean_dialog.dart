import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'num_pad.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController EanController = TextEditingController();
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('EAN Search'),
          content: Container(
            width: width * 0.6 + 10,
            height: height * 0.6,
            child: Row(
              children: [
                Container(
                  height: height * 0.6,
                  width: (width * 0.6) * 0.35,
                  child: Column(
                    children: [
                      TextField(
                        controller: EanController,
                        decoration: InputDecoration(
                          labelText: 'EAN',
                          suffixIcon: Icon(
                            Icons.code,
                            size: 17,
                          ),
                        ),
                      ),
                      NumPad(
                        buttonSize: 50,
                        buttonColor: Colors.grey,
                        iconColor: Colors.blueGrey,
                        controller: EanController,
                        delete: () {
                          EanController.text = EanController.text
                              .substring(0, EanController.text.length - 1);
                        },
                        // do something with the input numbers
                        onSubmit: () {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(GetEAN(EanController.text));
                          if (!state.gotitems) {
                            BlocProvider.of<CategoryBloc>(context)
                                .add(InitEvent());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: height * 0.6,
                  width: (width * 0.6) * 0.65,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 227, 227),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                      itemCount: state.eanitems.length,
                      itemBuilder: (cc, index) {
                        return Card(
                          child: ListTile(
                            title: Text(state.eanitems.elementAt(index).name),
                            subtitle: Text('EAN: ' +
                                state.eanitems.elementAt(index).PLU_EAN),
                            trailing: Text(state.eanitems
                                .elementAt(index)
                                .price
                                .toString()),
                            onTap: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                  UpdateOrderEvent(state.eanitems[index],
                                      state.categoryitems));
                              if (!state.gotitems) {
                                BlocProvider.of<CategoryBloc>(context)
                                    .add(InitEvent());
                              }
                            },
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
