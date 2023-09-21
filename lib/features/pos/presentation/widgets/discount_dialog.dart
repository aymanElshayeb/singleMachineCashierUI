import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscountDialog extends StatelessWidget {
  final String? title;
  final Function(double discount)? onPressed;
  const DiscountDialog({
    Key? key,
    this.onPressed,
    this.title = 'Total',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text('$title ${AppLocalizations.of(context)?.discount}'),
      content: SizedBox(
        width: width * 0.19,
        height: height * 0.08,
        child: TextField(
          controller: customController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.discount,
            suffixIcon: Icon(
              Icons.discount,
              size: width * 0.014,
            ),
          ),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Keyboard(
                  controller: customController,
                  number: true,
                );
              },
            );
          },
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            double discount = double.parse(customController.text);
            if (onPressed != null) {
              onPressed!(discount / 100);
            }

            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.submit),
        )
      ],
    );
  }
}
