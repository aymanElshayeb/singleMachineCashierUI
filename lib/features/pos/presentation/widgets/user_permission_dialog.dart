import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/virtual_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';

class UserPermissionDialog extends StatelessWidget {
  const UserPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController controller = TextEditingController();
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AuthenticatedAgain && state.currentUser.role == 'ADMIN') {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Column(
            children: [
              Text(AppLocalizations.of(context)!.adminpassword),
              SizedBox(
                width: width * 0.19,
                height: height * 0.08,
                child: TextField(
                  obscureText: true,
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.password,
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
                if (controller.text.isNotEmpty) {
                  BlocProvider.of<UserBloc>(context)
                      .add(SecondAuthenticate(controller.text));
                }
              },
              child: Text(AppLocalizations.of(context)!.submit),
            )
          ],
        );
      },
    );
  }
}
