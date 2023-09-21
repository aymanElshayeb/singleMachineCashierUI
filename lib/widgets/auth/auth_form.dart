import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext ctx) submitFn;
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  void _trysubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userPassword.trim(),
          _islogin, context);

      //auth request here!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 300,
      height: 400,
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: ((value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'please enter a valid email';
                    }
                    return null;
                  }),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email address'),
                  onSaved: ((newValue) => _userEmail = newValue!),
                ),
                if (!_islogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: ((value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'please enter atleast 4 characters';
                      }
                      return null;
                    }),
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: ((newValue) => _userName = newValue!),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: ((value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'password must be atleast 7 characters.';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: ((newValue) => _userPassword = newValue!),
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                      onPressed: _trysubmit,
                      child: Text(_islogin ? 'Login' : 'Signup')),
                if (!widget.isLoading)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _islogin = !_islogin;
                        });
                      },
                      child: Text(_islogin
                          ? 'Create new account'
                          : 'I already have an account'))
              ]),
            ),
          ),
        ),
      ),
    ));
  }
}
