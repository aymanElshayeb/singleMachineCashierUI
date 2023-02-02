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
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      child: Container(
          height: 55,
          padding: EdgeInsets.all(width * 0.01),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.9),
              borderRadius: BorderRadius.circular(5)),
          child: const Text(
            'settings',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal),
          )),
      onSelected: (SampleItem item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Bon History'),
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: ListTile(
            leading: const Icon(Icons.work_history),
            title: const Text('Last Bon'),
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Back'),
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          child: ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Add/Take Money'),
          ),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFive,
          child: ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Open Drawer'),
          ),
        ),
      ],
    );
  }
}
