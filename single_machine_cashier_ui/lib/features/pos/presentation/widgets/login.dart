import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  // Holds the text that user typed.
  String text = '';
  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;
  bool showKeyboard = false;
  // is true will show the numeric keyboard.
  bool isNumericMode = false;
  var txt = TextEditingController();
  TextEditingController _controllerText;

  @override
  void initState() {
    // _customLayoutKeys = CustomLayoutKeys();
    _controllerText = TextEditingController();
    super.initState();
  }

  //String inputStr;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: width / 2,
                    height: height / 2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // userInput('enter your username',false),
                          userInput('enter your password', true),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (showKeyboard ? virtual_keyboard() : Container())
              ],
            ),
          ),
        ));
  }

  Container virtual_keyboard() {
    return Container(
      color: Colors.black.withOpacity(.7),
      child: VirtualKeyboard(
          height: 300,
          //width: 500,
          textColor: Colors.white,
          textController: _controllerText,
          //customLayoutKeys: _customLayoutKeys,
          defaultLayouts: const [VirtualKeyboardDefaultLayouts.English],
          //reverseLayout :true,
          type: isNumericMode
              ? VirtualKeyboardType.Numeric
              : VirtualKeyboardType.Alphanumeric,
          onKeyPress: _onKeyPress),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      if (shiftEnabled == true) {
        text = text +
            (shiftEnabled ? key.capsText.toString() : key.text.toString());
      }
      text =
          text + (shiftEnabled ? key.capsText.toString() : key.text.toString());
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text.toString();
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }

  Padding userInput(String label, bool password) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        obscureText: password,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: _controllerText.text,
        ),
        // The validator receives the text that the user has entered.
        onChanged: (value) {
          //  inputStr = value;
        },
        onTap: () {
          setState(() {
            //   txt.text = _controllerText.text;
            showKeyboard = true;
          });
        },
        onFieldSubmitted: (_) {
          //  dispatchAuth();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}