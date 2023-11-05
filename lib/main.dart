import 'dart:io';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/auth_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/category_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/item_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/order_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/categories.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/orders.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/auth/auth_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/ean/ean_bloc.dart';
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
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String jsonString = await getConfigForFirebase();
  Map configMap = json.decode(jsonString);
  String googleClientId = configMap['google_clientId'];
  String firebaseAuthApiKey = configMap['auth_firebase_config']['apiKey'];
  String dataProjectId = configMap['data_firebase_config']['projectId'];
  String authProjectId = configMap['auth_firebase_config']['projectId'];
  if (Platform.isWindows) {
    GoogleSignInDart.register(clientId: googleClientId);
  }
  FirebaseAuth.initialize(firebaseAuthApiKey, VolatileStore());
  Logger.root.level = Level
      .ALL; // defaults to Level.INFO (so it overrides the log level to be able to view fine logs )
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.loggerName}] -- ${record.level.name} -- ${record.time} -- ${record.message}');
  });

  await di.init();

  runApp(MyApp(
    authProjectId: authProjectId,
    dataProjectId: dataProjectId,
  ));
}

Future<String> getConfigForFirebase() async =>
    await rootBundle.loadString('assets/config/firebase_config.json');

class MyApp extends StatelessWidget {
  final String? dataProjectId;
  final String? authProjectId;
  const MyApp({super.key, this.dataProjectId, this.authProjectId});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                authRepository: AuthRepository(
                    firebaseFirestore:
                        Firestore(authProjectId!).collection('users')))),
        BlocProvider(
            create: (_) => OrderBloc(
                orders: Orders(OrderRepositoryImpl(
                    firebaseFirestore: Firestore(dataProjectId!))))),
        BlocProvider(
            create: (_) => ItemBloc(
                items: Items(ItemRepositoryImpl(
                    firebaseFirestore: Firestore(dataProjectId!))))),
        BlocProvider(
          create: (_) => EanBloc(
              items: Items(ItemRepositoryImpl(
                  firebaseFirestore: Firestore(dataProjectId!)))),
        ),
        BlocProvider(
          create: (_) => sl<UserBloc>(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
              categories: Categories(CategoryRepositoryImpl(
                  firebaseFirestore: Firestore(dataProjectId!)))),
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
