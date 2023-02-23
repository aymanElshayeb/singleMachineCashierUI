import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../bloc/bloc/payment_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../widgets/num_pad.dart';

class ToPay extends StatelessWidget {
  final double total;
  const ToPay({Key key, @required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController _myController = TextEditingController();
    String selectedMethod = "Cash";
    return BlocProvider(
      create: (context) => PaymentBloc()..add(getTotal(total: total)),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Payment page"),
              backgroundColor: Colors.grey,
            ),
            backgroundColor: Color.fromARGB(255, 243, 243, 243),
            body: Row(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 227, 229, 230),
                        borderRadius: BorderRadius.all(Radius.circular(11.0))),
                    child: Column(children: [
                      numberBar(state.total, "Total"),
                      numberBar(state.cash, "Cash"),
                      numberBar(state.inreturn, "Return"),
                    ]),
                  ),

                  const SizedBox(
                    height: 140,
                  ),
                  paymentButton(Icons.print, 'Print receipt', () {}),
                  Container(
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: DropdownButton(
                      items: ["Cash", "Visa"]
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  "$e",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        BlocProvider.of<PaymentBloc>(context)
                            .add(UpdateMethod(method: val));
                        print(val);
                      },
                      value: state.selectedMethod,
                    ),
                  ),
                  paymentButton(Icons.payment, 'Complete payment', () {}),

                  //DropdownButton(items: [], onChanged: onChanged)
                ]),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Container(
                    width: 300,
                    height: 300,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 227, 229, 230),
                        borderRadius: BorderRadius.all(Radius.circular(11.0))),
                    child: NumPad(
                      buttonSize: 50,
                      buttonColor: Colors.grey,
                      iconColor: Colors.blueGrey,
                      controller: _myController,
                      delete: () {
                        _myController.text = _myController.text
                            .substring(0, _myController.text.length - 1);
                      },
                      // do something with the input numbers
                      onSubmit: () {
                        /*debugPrint('Your code: ${_myController.text}');
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  content: Text(
                                    "You code is ${_myController.text}",
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ));*/
                      },
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: width * 0.499,
                      height: height,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 227, 229, 230),
                          borderRadius:
                              BorderRadius.all(Radius.circular(11.0))),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 130,
                        height: 130,
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: Ink.image(
                              image: AssetImage('images/100.png'),
                              child: InkWell(
                                onTap: () {
                                  print("hey");
                                  BlocProvider.of<PaymentBloc>(context)
                                      .add(AddToCash(money: 100));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Container numberBar(double number, String title) {
    return Container(
      width: 300,
      height: 60,
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(title, style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
        Container(
            child: number == 0
                ? Text("")
                : Text(
                    number.toString(),
                    style: TextStyle(fontSize: 54, color: Colors.black),
                  ))
      ])),
    );
  }

  Container paymentButton(IconData icon, String title, Function function) {
    return Container(
      width: 300,
      height: 50,
      color: Colors.red,
      child: ElevatedButton.icon(
        onPressed: function,
        icon: Icon(
          // <-- Icon
          icon,
          size: 24.0,
        ),
        label: Text(title), // <-- Text
      ),
    );
  }
}
