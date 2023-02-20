import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../../injection_container.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_state.dart';
import '../widgets/login.dart';
import '../widgets/message_display.dart';
import 'menu.dart';

class LoginBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<UserBloc> buildBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    String text;

    _onKeyPress(VirtualKeyboardKey key) {
      if (key.keyType == VirtualKeyboardKeyType.String) {
        text = text + key.text;
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
            text = text + key.text;
            break;
          case VirtualKeyboardKeyAction.Shift:
            break;
          default:
        }
      }
    }

    return BlocProvider(
        create: (_) => sl<UserBloc>(),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Wrong Password")));
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height,
                    padding: const EdgeInsets.all(10),
                    child: Login(),
                  ),
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
                        //
                        defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                        // [A-Z, 0-9]
                        type: VirtualKeyboardType.Alphanumeric,
                        // Callback for key press event
                        onKeyPress: _onKeyPress),
                  )
                ],
              ),
            );
          },
        ));
  }
}
