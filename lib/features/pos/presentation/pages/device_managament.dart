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
    //final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(title: Text('Device managament')),
      body: Container(color: Colors.green),
    );
  }
}
