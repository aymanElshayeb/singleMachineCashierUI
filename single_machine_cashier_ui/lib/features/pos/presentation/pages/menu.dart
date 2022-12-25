import 'package:flutter/material.dart';

import '../widgets/bill.dart';
import '../widgets/menu_items.dart';
import '../widgets/popup_menu.dart';
import '../widgets/table.dart';
import 'constants.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          width: double.infinity,
          height: height * 0.1,
          decoration: BoxDecoration(
              color: seconderyColor, borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: width * 0.15),
                child: const Text(
                  '40.37',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.02),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PopupMenu(),
                    menu_button(width, Icons.lock, 'item1'),
                    menu_button(width, Icons.home, 'item1'),
                    menu_button(width, Icons.power_off_rounded, 'item1')
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.9,
                width: width * 0.3,
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                    color: seconderyColor,
                    borderRadius: BorderRadius.circular(15)),
                child: BillPart()
              ),
              Container(
                height: height * 0.9,
                width: width * 0.66,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                    color: seconderyColor,
                    borderRadius: BorderRadius.circular(15)),
                child: MenuItems(),
              ),
            ],
          ),
        )
      ]),
    ));
  }

  Container menu_button(double width, IconData icon, String label) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(width * 0.01),
      child: ElevatedButton.icon(
        icon: Icon(icon), //icon data for elevated button
        label: Text(label), //label text
        style: ElevatedButton.styleFrom(
          primary: Colors.grey.withOpacity(0.6),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontStyle: FontStyle.normal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: (() {}),
      ),
    );
  }
}
