import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'num_pad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController EanController = TextEditingController();
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.eansearch),
          content: Container(
            width: width * 0.4,
            height: height * 0.7,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.38,
                      height: height * 0.08,
                      child: TextField(
                        controller: EanController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.eansearch,
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
                    ),
                    InkWell(
                      child: Icon(Icons.search),
                      onTap: (() {
                        if (EanController.text.isNotEmpty) {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(GetEAN(EanController.text));
                          if (!state.gotitems) {
                            BlocProvider.of<CategoryBloc>(context)
                                .add(InitEvent());
                          }
                        }
                      }),
                    )
                  ],
                ),
                Container(
                  height: height * 0.6,
                  width: (width * 0.6) * 0.65,
                  decoration: BoxDecoration(
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
