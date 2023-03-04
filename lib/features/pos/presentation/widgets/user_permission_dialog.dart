import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';

class UserPermissionDialog extends StatelessWidget {
  const UserPermissionDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController controller = TextEditingController();

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.currentUser.role == 'ADMIN') {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Wrong Password")));
        }
      },
      child: AlertDialog(
        title: Column(
          children: [
            Text('Please, Enter Admin password'),
            Container(
              width: width * 0.19,
              height: height * 0.08,
              child: TextField(
                obscureText: true,
                controller: controller,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).password,
                  suffixIcon: Icon(
                    Icons.remove_red_eye,
                    size: width * 0.014,
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
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (controller.text.length > 0) {
                BlocProvider.of<UserBloc>(context)
                    .add(SecondAuthenticate(controller.text));
              }
            },
            child: Text(AppLocalizations.of(context).submit),
          )
        ],
      ),
    );
  }
}
