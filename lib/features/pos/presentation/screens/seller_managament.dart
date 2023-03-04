import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/bloc.dart';
import '../../../../injection_container.dart';

import '../../domain/entities/user.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/table.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/virtual_keyboard.dart';

class SellerMangament extends StatelessWidget {
  SellerMangament({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar =
        AppBar(title: Text(AppLocalizations.of(context).sellermanagement));
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    return BlocProvider(
      create: (context) => sl<UserBloc>()..add(GetAllUsers()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: appBar,
            //backgroundColor: Colors.grey,
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: (screenheight - appBarHeight) * 0.43,
                  width: screenwidth,
                  decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 228, 227, 227),
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(children: [
                    Text(
                      AppLocalizations.of(context).newusercredentials,
                      //style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: screenheight * 0.05,
                    ),
                    Container(
                      width: screenwidth * 0.19,
                      height: screenheight * 0.08,
                      child: TextField(
                        controller: controller1,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).fullname,
                          suffixIcon: Icon(
                            Icons.abc,
                            size: screenwidth * 0.014,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Keyboard(
                                controller: controller1,
                                number: false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: screenwidth * 0.19,
                      height: screenheight * 0.08,
                      child: TextField(
                        controller: controller2,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).username,
                          suffixIcon: Icon(
                            Icons.abc,
                            size: screenwidth * 0.014,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Keyboard(
                                controller: controller2,
                                number: false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: screenwidth * 0.19,
                      height: screenheight * 0.08,
                      child: TextField(
                        obscureText: true,
                        controller: controller3,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).password,
                          suffixIcon: Icon(
                            Icons.remove_red_eye,
                            size: screenwidth * 0.014,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Keyboard(
                                controller: controller3,
                                number: false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.02,
                    ),
                    Container(
                      width: screenwidth * 0.11,
                      height: screenheight * 0.05,
                      child: MaterialButton(
                          color: Theme.of(context).primaryColorDark,
                          onPressed: () {
                            if (controller1.text != '' &&
                                controller2.text != '' &&
                                controller3.text != '') {
                              BlocProvider.of<UserBloc>(context).add(AddUser(
                                  User(
                                      fullname: controller1.text,
                                      role: 'Cashier',
                                      userName: controller2.text,
                                      password: controller3.text,
                                      id: 5)));
                              controller1.text = '';
                              controller2.text = '';
                              controller3.text = '';
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Enter sufficient credentials!")));
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context).addanewuser)),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: (screenheight - appBarHeight) * 0.535,
                  width: 450,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 228, 227, 227),

                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: MenuDataTable([
                      AppLocalizations.of(context).fullname,
                      AppLocalizations.of(context).username,
                      AppLocalizations.of(context).role
                    ], getUsersTable(state.users)),
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }

  List<List<String>> getUsersTable(List<User> users) {
    List<List<String>> table = [];
    for (var i = 0; i < users.length; i++) {
      table.add([users[i].fullname, users[i].userName, users[i].role]);
    }
    return table;
  }
}
