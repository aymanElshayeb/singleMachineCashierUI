

// import 'package:flutter/material.dart';
// import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
//
// class keyboard extends StatefulWidget {
//   const keyboard({super.key});
//
//   @override
//   State<keyboard> createState() => _keyboardState();
// }
//
// class _keyboardState extends State<keyboard> {
//   // Holds the text that user typed.
//   String text = '';
//   // CustomLayoutKeys _customLayoutKeys;
//   // True if shift enabled.
//   bool shiftEnabled = false;
//   bool showKeyboard = false;
//   // is true will show the numeric keyboard.
//   bool isNumericMode = false;
//   var txt = TextEditingController();
//   late TextEditingController _controllerText;
//
//   @override
//   void initState() {
//     // _customLayoutKeys = CustomLayoutKeys();
//     _controllerText = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.grey,
//         child: VirtualKeyboard(
//             height: 300,
//             //width: 500,
//             textColor: Colors.white,
//             textController: _controllerText,
//             //customLayoutKeys: _customLayoutKeys,
//             defaultLayouts: [
//               VirtualKeyboardDefaultLayouts.Arabic,
//               VirtualKeyboardDefaultLayouts.English
//             ],
//             //reverseLayout :true,
//             type: isNumericMode
//                 ? VirtualKeyboardType.Numeric
//                 : VirtualKeyboardType.Alphanumeric,
//             onKeyPress: _onKeyPress),
//       ),
//     );
//   }
//
//   _onKeyPress(VirtualKeyboardKey key) {
//     if (key.keyType == VirtualKeyboardKeyType.String) {
//       if (shiftEnabled == true) {
//         text = text +
//             (shiftEnabled ? key.capsText.toString() : key.text.toString());
//       }
//       text =
//           text + (shiftEnabled ? key.capsText.toString() : key.text.toString());
//     } else if (key.keyType == VirtualKeyboardKeyType.Action) {
//       switch (key.action) {
//         case VirtualKeyboardKeyAction.Backspace:
//           if (text.length == 0) return;
//           text = text.substring(0, text.length - 1);
//           break;
//         case VirtualKeyboardKeyAction.Return:
//           text = text + '\n';
//           break;
//         case VirtualKeyboardKeyAction.Space:
//           text = text + key.text.toString();
//           break;
//         case VirtualKeyboardKeyAction.Shift:
//           shiftEnabled = !shiftEnabled;
//           break;
//         default:
//       }
//     }
//     // Update the screen
//     setState(() {});
//   }
// }