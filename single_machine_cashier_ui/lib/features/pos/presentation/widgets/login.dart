import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/authenticate_user.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            width: width / 2,
            height: height / 2,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // userInput('enter your username',false),
                  userInput('enter your password',true),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Padding userInput(String label,bool password) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        obscureText:password,
        decoration:  InputDecoration(
          border: OutlineInputBorder(borderRadius:BorderRadius.circular(15)),
          labelText: label,
        ),
        // The validator receives the text that the user has entered.
        onChanged: (value) {
          inputStr = value;
        },
        onFieldSubmitted: (_) {
          dispatchAuth();
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
  void dispatchAuth() {
    controller.clear();
    BlocProvider.of<UserBloc>(context)
        .add(AuthenticateUserEvent(inputStr));
  }

}


