import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firebase/firebase_category_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firebase/firebase_items_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firebase/firebase_order_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firedart/firedart_category_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firedart/firedart_items_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/firedart/firedart_order_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/node/node_category_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/node/node_items_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/node/node_order_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/odoo/odoo_category_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/odoo/odoo_items_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/odoo/odoo_order_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/category_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/items_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/order_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/categories.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/orders.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/ean/ean_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/item/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/device_managament.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/home_page.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/payment_screen.dart';
import 'package:single_machine_cashier_ui/firebase_web.dart';
import 'features/pos/presentation/bloc/Locale/locale_bloc_bloc.dart';
import 'features/pos/presentation/bloc/categories/category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:authentication_module/authentication_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = await getConfigForFirebase();
  Map configMap = json.decode(jsonString);
  Map dataProjectConfig = configMap['data_firebase_config'];
  Map authProjectConfig = configMap['auth_firebase_config'];
  if (kIsWeb) {
    FirebaseWeb.webInitializeFirebase(dataProjectConfig, authProjectConfig);
  } else {
    FirebaseAuth.initialize(authProjectConfig['apiKey'], VolatileStore());
  }
  Logger.root.level = Level
      .ALL; // defaults to Level.INFO (so it overrides the log level to be able to view fine logs )
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '[${record.loggerName}] -- ${record.level.name} -- ${record.time} -- ${record.message}');
  });
  final authService = AuthService();
  final bool isAuthenticated = await authService.isAuthenticated();

  runApp(MyApp(
    prefs: prefs,
    isAuthenticated: isAuthenticated,
    authProjectId: authProjectConfig['projectId'],
    dataProjectId: dataProjectConfig['projectId'],
  ));
}

Future<String> getConfigForFirebase() async =>
    await rootBundle.loadString('assets/config/firebase_config.json');

class MyApp extends StatelessWidget {
  final String? dataProjectId;
  final bool? isAuthenticated;
  final SharedPreferences prefs;
  final String? authProjectId;
  const MyApp({
    super.key,
    this.dataProjectId,
    this.isAuthenticated,
    required this.prefs,
    this.authProjectId,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                  authRepository: AuthRepositoryImpl(
                      dataSource: const String.fromEnvironment('DATA_SOURCE'),
                      nodeDataSource: NodeAuthDataSource(
                          secureStorage: secureStorage,
                          sharedPreferences: prefs,
                          systemName: 'POS'),
                      odooDataSource: OdooAuthDataSource(
                          secureStorage: secureStorage, systemName: 'POS')),
                )),
        BlocProvider(
            create: (_) => OrderBloc(
                    orders: Orders(
                  repository: OrderRepositoryImpl(
                      nodeDataSource: NodeOrderDataSource(),
                      fireBaseDataSource: FireBaseOrderDataSource(),
                      fireDartDataSource: FireDartOrderDataSource(
                          firebaseFirestore: Firestore(dataProjectId!)),
                      odooDataSource: OdooOrderDataSource()),
                ))),
        BlocProvider(
            create: (_) => ItemBloc(
                    items: Items(
                  repository: ItemsRepositoryImpl(
                      nodeDataSource: NodeItemsDataSource(),
                      fireBaseDataSource: FireBaseItemsDataSource(),
                      fireDartDataSource: FireDartItemsDataSource(
                          firebaseFirestore: Firestore(dataProjectId!)),
                      odooDataSource: OdooItemsDataSource()),
                ))),
        BlocProvider(
          create: (_) => EanBloc(
              items: Items(
            repository: ItemsRepositoryImpl(
                nodeDataSource: NodeItemsDataSource(),
                fireBaseDataSource: FireBaseItemsDataSource(),
                fireDartDataSource: FireDartItemsDataSource(
                    firebaseFirestore: Firestore(dataProjectId!)),
                odooDataSource: OdooItemsDataSource()),
          )),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
              categories: Categories(
            repository: CategoryRepositoryImpl(
                nodeDataSource: NodeCategoryDataSource(),
                fireBaseDataSource: FirebaseCategoryDataSource(),
                fireDartDataSource: FireDartCategoryDataSource(
                    firebaseFirestore: Firestore(dataProjectId!)),
                odooDataSource: OdooCategoryDataSource()),
          )),
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
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.dark(),
            title: 'POS',
            locale: state.locale,
            initialRoute: isAuthenticated! ? '/home' : '/auth',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/auth':
                  return MaterialPageRoute(
                      builder: (context) => const AuthPage());
                case '/home':
                  return MaterialPageRoute(
                      builder: (context) => const HomePage());
                case '/payment':
                  final double totalPrice = settings.arguments as double;
                  return MaterialPageRoute(
                      builder: (context) =>
                          PaymentScreen(totalPrice: totalPrice));
                case 'device-management':
                  final List<Printer> printers =
                      settings.arguments as List<Printer>;
                  return MaterialPageRoute(
                      builder: (context) => DeviceMangament(
                            printers: printers,
                          ));
              }

              return null;
            },
            home: isLoggedIn ? const HomePage() : null,
          );
        },
      ),
    );
  }
}
