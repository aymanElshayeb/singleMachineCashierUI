import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class Keyboard extends StatelessWidget {
  final TextEditingController controller;
  final number;
  const Keyboard({Key key, @required this.controller, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // Wrap the keyboard with Container to set background color.
        Container(
            // Keyboard is transparent
            color: Colors.black,
            child: VirtualKeyboard(
              // Default height is 300
              height: 350,
              // Default is black
              textColor: Colors.white,
              textController: controller,
              // Default 14
              fontSize: 20,
              // [A-Z, 0-9]
              type: number
                  ? VirtualKeyboardType.Numeric
                  : VirtualKeyboardType.Alphanumeric,
              // Callback for key press event
            ));
  }
}
