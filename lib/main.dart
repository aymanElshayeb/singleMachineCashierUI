import 'dart:io';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/auth_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/auth/auth_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/bloc/ean_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/item/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/auth.dart';
import 'features/pos/presentation/bloc/Locale/locale_bloc_bloc.dart';
import 'features/pos/presentation/bloc/categories/category_bloc.dart';
import 'features/pos/presentation/bloc/user/user_bloc.dart';
import 'injection_container.dart' as di;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'injection_container.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

// late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    GoogleSignInDart.register(
        clientId:
            '11927002349-t0tnt1178rju3tt4js5qvajmjphm8rk0.apps.googleusercontent.com');
  }
  FirebaseAuth.initialize(
      'AIzaSyAO2bpCzMMEXabEh2JZuBFc3QhWFXS4Kn8', VolatileStore());
  Logger.root.level = Level
      .ALL; // defaults to Level.INFO (so it overrides the log level to be able to view fine logs )
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.loggerName}] -- ${record.level.name} -- ${record.time} -- ${record.message}');
  });

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider(create: (_) => sl<OrderBloc>()),
        BlocProvider(create: (_) => sl<ItemBloc>()),
        BlocProvider(
          create: (_) => sl<EanBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<UserBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>(),
        ),
        BlocProvider(
          create: (BuildContext context) {
            return LocaleBlocBloc(LocaleBlocState.initial());
          },
        ),
      ],
      child: BlocBuilder<LocaleBlocBloc, LocaleBlocState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.dark(),
            locale: state.locale,
            home: const AuthenticationPage(),
          );
        },
      ),
    );
  }
}
