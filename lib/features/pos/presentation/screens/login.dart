import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../../injection_container.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_state.dart';
import '../widgets/login.dart';
import 'menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

    return BlocProvider(
        create: (_) => sl<UserBloc>(),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is Authenticated) {
              final currentBloc = context.read<UserBloc>();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => BlocProvider.value(
                            value: currentBloc,
                            child: MyHomePage(),
                          ))));
            } else {
              if (state.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Wrong Password")));
              }
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
                ],
              ),
            );
          },
        ));
  }
}
