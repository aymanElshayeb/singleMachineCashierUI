import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.alert),
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
            BlocProvider.of<OrderBloc>(context).add(DeleteOrder());

            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.continuee),
        )
      ],
    );
  }
}
