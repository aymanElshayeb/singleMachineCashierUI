import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'features/pos/data/objectbox.dart';
import 'features/pos/presentation/bloc/Locale/locale_bloc_bloc.dart';
import 'features/pos/presentation/bloc/cart/cart_bloc.dart';
import 'features/pos/presentation/bloc/category/category_bloc.dart';
import 'features/pos/presentation/bloc/category/category_event.dart';
import 'features/pos/presentation/bloc/user/user_bloc.dart';
import 'features/pos/presentation/screens/login.dart';
import 'injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'injection_container.dart';
import 'objectbox.g.dart';

late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
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
          create: (_) => sl<UserBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(InitEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) {
            return LocaleBlocBloc(LocaleBlocState.initial());
          },
        ),
        BlocProvider(
          create: (_) => CartBloc(),
        ),
      ],
      child: BlocBuilder<LocaleBlocBloc, LocaleBlocState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.dark(),
            locale: state.locale,
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
