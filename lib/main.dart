import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/user_bloc.dart';
import 'features/pos/presentation/bloc/category/category_bloc.dart';
import 'features/pos/presentation/screens/login.dart';
import 'injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  Logger.root.level = Level
      .ALL; // defaults to Level.INFO (so it overrides the log level to be able to view fine logs )
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}] -- ${record.level.name} -- ${record.time} -- ${record.message}');
  });
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return UserBloc();
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return CategoryBloc();
          },
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: LoginBuilder(),
      ),
    );
  }
}
