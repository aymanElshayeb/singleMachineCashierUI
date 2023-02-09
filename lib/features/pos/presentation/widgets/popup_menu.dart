import 'package:flutter/material.dart';

// This is the type used by the popup menu below.
enum SampleItem { itemOne, itemTwo, itemThree, itemFour, itemFive }

class PopupMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  SampleItem selectedMenu;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 35,
      width: 100,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(5)),
      child: PopupMenuButton<SampleItem>(
        initialValue: selectedMenu,
        child: Row(
          children: [
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            const Text(
              'Office',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.normal),
            ),
          ],
        ),
        onSelected: (SampleItem item) {
          setState(() {
            selectedMenu = item;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemOne,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Seller management'),
            ),
          ),
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo,
            child: ListTile(
              leading: const Icon(Icons.device_hub),
              title: const Text('Device management'),
            ),
          ),
        ],
      ),
    );
  }
}
