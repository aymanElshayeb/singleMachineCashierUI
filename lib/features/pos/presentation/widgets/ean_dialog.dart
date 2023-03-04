import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'num_pad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

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
          title: Text(AppLocalizations.of(context).eansearch),
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
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Keyboard(
                                controller: EanController,
                                number: false,
                              );
                            },
                          );
                        },
                      ),
                      NumPad(
                        buttonSize: 50,
                        //buttonColor: Colors.grey,
                        //iconColor: Colors.blueGrey,
                        buttonColor: Theme.of(context).canvasColor,
                        iconColor:
                            Theme.of(context).appBarTheme.foregroundColor,

                        controller: EanController,
                        delete: () {
                          if (EanController.text.length > 0) {
                            EanController.text = EanController.text
                                .substring(0, EanController.text.length - 1);
                          }
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
                      //color: Color.fromARGB(255, 228, 227, 227),
                      color: Theme.of(context).backgroundColor,
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
