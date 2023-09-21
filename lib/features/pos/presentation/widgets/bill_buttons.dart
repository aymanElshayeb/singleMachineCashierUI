import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/payment_screen.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/discount_dialog.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/split_bill_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/constants.dart';
import 'confirm_dialog.dart';
import 'different_item_dialog.dart';
import 'ean_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillButtons extends StatelessWidget {
  final BuildContext context;
  const BillButtons({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttons = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.pay,
        'icon': const Icon(Icons.payment),
        'function': () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PaymentScreen(
                      totalPrice: BlocProvider.of<OrderBloc>(context)
                          .state
                          .totalPrice))));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.split,
        'icon': const Icon(Icons.splitscreen),
        'function': () {
          showDialog(
              context: context,
              builder: (((cc) {
                return SplitBill();
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.differentitem,
        'icon': const Icon(Icons.add_box),
        'function': () {
          showDialog(
              context: context,
              builder: (((cc) {
                return const DifferentItem();
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.discount,
        'icon': const Icon(Icons.discount),
        'function': () {
          showDialog(
              context: context,
              builder: (((cc) {
                return DiscountDialog(
                  onPressed: (discount) {
                    BlocProvider.of<OrderBloc>(context)
                        .add(AddDiscountToOrder(discount: discount));
                  },
                );
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.eansearch,
        'icon': const Icon(Icons.manage_search_sharp),
        'function': () {
          showDialog(
              context: context,
              builder: (((cc) {
                return const CustomDialog();
              })));
        }
      },
      <String, dynamic>{
        'title': AppLocalizations.of(context)?.cancel,
        'icon': const Icon(Icons.cancel),
        'function': () {
          showDialog(
              context: context,
              builder: (((cc) {
                return const ConfirmDialog();
              })));
        }
      },
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: 0.2 * height,
      child: GridView.builder(
        itemCount: buttons.length, //should be length of the items list
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height),
            crossAxisCount: 3,
            crossAxisSpacing: width * 0.004,
            mainAxisSpacing: width * 0.004),
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  color: seconderyColor.withOpacity(1.0),
                  fontSize: height * 0.017,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: buttons[index]['function'],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttons[index]['icon'],
                  Text(
                    buttons[index]['title'],
                  ),
                ],
              ));
        },
      ),
    );
  }
}
