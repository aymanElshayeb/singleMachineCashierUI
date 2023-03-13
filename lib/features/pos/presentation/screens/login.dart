import 'package:single_machine_cashier_ui/features/pos/domain/usecases/authenticate_user.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../widgets/Language_popup.dart';
import '../widgets/virtual_keyboard.dart';
import 'menu.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final TextEditingController controller = TextEditingController();
    return BlocListener<UserBloc, UserState>(
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
          if (state.currentUser ==
              User(fullname: '', role: '', password: '', userName: '')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Wrong Password")));
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            width: screenwidth * 0.35,
            height: screenheight * 0.6,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    AppLocalizations.of(context)!.welcomeback,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  width: screenwidth * 0.19,
                  height: screenheight * 0.08,
                  margin: EdgeInsets.all(40),
                  child: TextField(
                    obscureText: true,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.password,
                      suffixIcon: Icon(
                        Icons.abc,
                        size: screenwidth * 0.014,
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Keyboard(
                            controller: controller,
                            number: false,
                          );
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<UserBloc>(context)
                          .add(AuthenticateUserEvent(controller.text));
                    },
                    child: Text(AppLocalizations.of(context)!.login)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
