import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeviceMangament extends StatelessWidget {
  const DeviceMangament({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final selectedMethod = 'printer1';
    final selectedMethod2 = 'drawer1';
    //final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(title: Text('Device managament')),
      body: Center(
        child: Container(
          width: screenwidth * 0.7,
          height: screenheight * 0.9,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 228, 227, 227),
              borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.all(8),
              child: Text(
                'Printer settings',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 218, 218, 218),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: DropdownButton(
                    items: ["printer1", "printer2"]
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                "$e",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      print(val);
                    },
                    value: selectedMethod,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(onPressed: () {}, child: Text('Test'))
              ],
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.all(8),
              child: Text(
                'Drawer settings',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 218, 218, 218),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: DropdownButton(
                    items: ["drawer1", "drawer2"]
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                "$e",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      print(val);
                    },
                    value: selectedMethod2,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(onPressed: () {}, child: Text('Test'))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
