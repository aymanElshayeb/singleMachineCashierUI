import 'package:flutter/material.dart';

class SessionEndedDialog extends StatelessWidget {
  const SessionEndedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Session Ended'),
      content: Text('Your session has ended. Please sign in again to continue.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/auth');
          },
          child: Text('Sign In'),
        ),
      ],
    );
  }
}
