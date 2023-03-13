import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../bloc/PaymentBloc/payment_bloc.dart';
import 'package:provider/provider.dart';

class Currency extends StatelessWidget {
  const Currency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final _log = Logger('ToPay');
    List<Map<String, dynamic>> currencies = <Map<String, dynamic>>[
      <String, dynamic>{'title': 'euro/1', 'value': 1},
      <String, dynamic>{'title': 'euro/2', 'value': 2},
      <String, dynamic>{'title': 'euro/5', 'value': 5},
      <String, dynamic>{'title': 'euro/10', 'value': 10},
      <String, dynamic>{'title': 'euro/20', 'value': 20},
      <String, dynamic>{'title': 'euro/50', 'value': 50},
      <String, dynamic>{'title': 'euro/100', 'value': 100},
      <String, dynamic>{'title': 'euro/200', 'value': 200},
      <String, dynamic>{'title': 'euro/500', 'value': 500},
      <String, dynamic>{'title': 'cent/1', 'value': 0.01},
      <String, dynamic>{'title': 'cent/2', 'value': 0.02},
      <String, dynamic>{'title': 'cent/5', 'value': 0.05},
      <String, dynamic>{'title': 'cent/10', 'value': 0.1},
      <String, dynamic>{'title': 'cent/20', 'value': 0.2},
    ];

    return Stack(
      children: [
        Container(
          width: width * 0.499,
          height: height,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(11.0))),
        ),
        Container(
          width: width * 0.499,
          child: GridView.builder(
            itemCount: currencies.length, //should be length of the items list
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height) *
                    0.8,
                crossAxisCount: 4,
                crossAxisSpacing: width * 0.004,
                mainAxisSpacing: width * 0.004),
            itemBuilder: (BuildContext context, int index) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  width: width * 0.11,
                  height: height * 0.11,
                  margin: EdgeInsets.all(15.0),
                  child: Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Ink.image(
                        image: AssetImage(
                            'assets/images/${currencies[index]['title']}.png'),
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<PaymentBloc>(context).add(
                                AddToCash(money: currencies[index]['value']));
                            _log.fine(currencies[index]['value']);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
