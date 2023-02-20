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
  final num total;
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
                      numberBar(
                          state.total, "Total", width * 0.230, height * 0.077),
                      numberBar(
                          state.cash, "Cash", width * 0.230, height * 0.077),
                      numberBar(state.inreturn, "Return", width * 0.230,
                          height * 0.077),
                    ]),
                  ),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  paymentButton(Icons.print, 'Print receipt', () {},
                      width * 0.221, height * 0.07),
                  Container(
                    width: width * 0.221,
                    height: height * 0.07,
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
                  paymentButton(Icons.payment, 'Complete payment', () {},
                      width * 0.221, height * 0.07),
                ]),
                SizedBox(
                  width: width * 0.02,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Container(
                    width: width * 0.2,
                    height: height * 0.45,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 227, 229, 230),
                        borderRadius: BorderRadius.all(Radius.circular(11.0))),
                    child: NumPad(
                      buttonSize: width * 0.04,
                      buttonColor: Colors.grey,
                      iconColor: Colors.blueGrey,
                      controller: _myController,
                      delete: () {
                        if (_myController.text.length > 0) {
                          _myController.text = _myController.text
                              .substring(0, _myController.text.length - 1);
                        }
                      },
                      // do something with the input numbers
                      onSubmit: () {},
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
                        width: width * 0.11,
                        height: height * 0.11,
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: Ink.image(
                              image: AssetImage('assets/images/100.png'),
                              child: InkWell(
                                onTap: () {
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

  Container numberBar(num number, String title, double width, double height) {
    return Container(
      width: width,
      height: height,
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
                    style: TextStyle(fontSize: 45, color: Colors.black),
                  ))
      ])),
    );
  }

  Container paymentButton(IconData icon, String title, Function function,
      double width, double height) {
    return Container(
      width: width,
      height: height,
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
