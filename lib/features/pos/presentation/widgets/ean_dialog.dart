import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/ean/ean_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/session_ended_dialog.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController eanController = TextEditingController();
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.eansearch),
      content: SizedBox(
        width: width * 0.4,
        height: height * 0.7,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.38,
                  height: height * 0.08,
                  child: TextField(
                    controller: eanController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.eansearch,
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Keyboard(
                            controller: eanController,
                            number: false,
                          );
                        },
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: (() {
                    if (eanController.text.isNotEmpty) {
                      BlocProvider.of<EanBloc>(context)
                          .add(LoadEanItems(eanController.text));
                    }
                  }),
                  child: const Icon(Icons.search),
                )
              ],
            ),
            Container(
                height: height * 0.6,
                width: (width * 0.6) * 0.65,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(15)),
                child: BlocConsumer<EanBloc, EanState>(
                  bloc: BlocProvider.of(context)..add(EmptyEan()),
                  listener: (context, state) {
                    if (state is SessionEndedState) {
                      showDialog(
                        context: context,
                        builder: (context) => const SessionEndedDialog(),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is EanInitial) {
                      return const Center(
                        child: Icon(Icons.remove_shopping_cart_outlined),
                      );
                    }
                    if (state is EanItemsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ItemError) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is EanItemsLoaded) {
                      return ListView.builder(
                          itemCount: state.items.length,
                          itemBuilder: (cc, index) {
                            return Card(
                              child: ListTile(
                                title: Text(state.items[index].name),
                                subtitle:
                                    Text('EAN: ${state.items[index].PLU_EAN} '),
                                trailing: Text(
                                    state.items[index].unitPrice.toString()),
                                onTap: () {
                                  BlocProvider.of<OrderBloc>(context).add(
                                      AddItemToOrder(item: state.items[index]));
                                },
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('unknown state'),
                      );
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
