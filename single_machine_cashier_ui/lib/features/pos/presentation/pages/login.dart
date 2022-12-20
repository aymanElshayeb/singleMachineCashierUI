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
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<UserBloc> buildBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => sl<UserBloc>(),
      child: Center(
        child: Container(
         width: width,
          height: height,
          padding: const EdgeInsets.all(10),
            child: Login(),
      ),
      ));
  }
}

