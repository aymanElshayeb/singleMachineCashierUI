import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/user_bloc.dart';
import 'features/pos/presentation/bloc/category/category_bloc.dart';
import 'features/pos/presentation/pages/login.dart';
import 'features/pos/presentation/pages/menu.dart';
import 'features/pos/presentation/pages/new_menu.dart';
import 'features/pos/presentation/pages/num_pad.dart';
import 'features/pos/presentation/pages/seller_managament.dart';
import 'features/pos/presentation/pages/to_pay.dart';
import 'injection_container.dart' as di;

void main() async {
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
        home: LoginBuilder(),
        //home: SellerMangament(),
      ),
    );
  }
}
