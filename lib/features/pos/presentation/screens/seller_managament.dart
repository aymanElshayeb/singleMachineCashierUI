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

class SellerMangament extends StatelessWidget {
  final appBar = AppBar(title: Text('Seller managament'));
  SellerMangament({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.grey,
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: (screenheight - appBarHeight) * 0.43,
                  width: screenwidth,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 227, 227),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(children: [
                    Text(
                      'New user credentials',
                      style: TextStyle(fontSize: 15, color: Colors.blueGrey),
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
                          labelText: 'Fullname',
                          suffixIcon: Icon(
                            Icons.abc,
                            size: screenwidth * 0.014,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenwidth * 0.19,
                      height: screenheight * 0.08,
                      child: TextField(
                        controller: controller2,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          suffixIcon: Icon(
                            Icons.abc,
                            size: screenwidth * 0.014,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenwidth * 0.19,
                      height: screenheight * 0.08,
                      child: TextField(
                        controller: controller3,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Icon(
                            Icons.remove_red_eye,
                            size: screenwidth * 0.014,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.02,
                    ),
                    Container(
                      width: screenwidth * 0.11,
                      height: screenheight * 0.05,
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller1.text != '' &&
                                controller2.text != '' &&
                                controller3.text != '') {
                              BlocProvider.of<UserBloc>(context).add(AddUser(
                                  User(
                                      fullname: controller1.text,
                                      role: 'ADMIN',
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
                          child: Text('Add a new user')),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: (screenheight - appBarHeight) * 0.535,
                  width: screenwidth * 0.28,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 227, 227),
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: MenuDataTable(['Full name', 'Username', 'Role'],
                        getUsersTable(state.users)),
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
