import 'package:flutter/material.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

class GlobalTextField extends StatelessWidget {
  final TextEditingController customController;
  final String labelText;
  final IconData iconData;
  final bool isNumber;

  const GlobalTextField(
      {super.key,
      required this.customController,
      required this.labelText,
      required this.iconData,
      required this.isNumber});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.19,
      height: height * 0.08,
      child: TextField(
        controller: customController,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(
            iconData,
            size: width * 0.014,
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Keyboard(
                controller: customController,
                number: isNumber,
              );
            },
          );
        },
      ),
    );
  }
}
