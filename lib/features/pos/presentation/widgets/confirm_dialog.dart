import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(AppLocalizations.of(context)!.cancelorder),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            MaterialButton(
              onPressed: () {
                BlocProvider.of<CategoryBloc>(context).add(CancelOrder());

                if (state.gotitems == false) {
                  BlocProvider.of<CategoryBloc>(context).add(InitEvent());
                }
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.continuee),
            )
          ],
        );
      },
    );
  }
}
