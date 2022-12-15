import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../widgets/login.dart';
import '../widgets/message_display.dart';

class LoginBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<UserBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return MessageDisplay(
                      message: 'user logged in successfully',
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                },
              ),

              // Bottom half
              Login()
            ],
          ),
        ),
      ),
    );
  }
}

