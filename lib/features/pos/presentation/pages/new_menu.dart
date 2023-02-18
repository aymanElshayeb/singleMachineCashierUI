import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class Menu extends StatelessWidget {
  Menu({Key key}) : super(key: key);
  final appBar = AppBar(
    title: Text(
      '59',
      style: TextStyle(backgroundColor: Colors.grey, fontSize: 40),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: screenwidth,
        height: (screenheight - appBarHeight - statusBarHeight),
        color: Colors.green,
        child: Row(children: [
          Container(
            width: screenwidth * 0.3,
            color: Colors.green,
            child: Column(children: [Container(), Container()]),
          ),
          Container(
            width: screenwidth * 0.7,
            color: Colors.red,
            child: // Wrap the keyboard with Container to set background color.
                Container(
              // Keyboard is transparent
              color: Colors.deepPurple,
              child: VirtualKeyboard(
                  // Default height is 300
                  height: 350,
                  // Default height is will screen width
                  width: 600,
                  // Default is black
                  textColor: Colors.white,
                  // Default 14
                  fontSize: 20,
                  // the layouts supported
                  defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                  // [A-Z, 0-9]
                  type: VirtualKeyboardType.Alphanumeric,
                  // Callback for key press event
                  onKeyPress: () {}),
            ),
          )
        ]),
      ),
    );
  }
}
