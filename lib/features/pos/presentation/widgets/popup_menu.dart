import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/device_managament.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/seller_managament.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Text(
              AppLocalizations.of(context).office,
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
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemOne,
            child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Seller management'),
                onTap: () => gotoPage('seller')),
          ),
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo,
            child: ListTile(
              leading: const Icon(Icons.device_hub),
              title: const Text('Device management'),
              onTap: () => gotoPage('device'),
            ),
          ),
        ],
      ),
    );
  }

  void gotoPage(String pageName) {
    switch (pageName) {
      case 'seller':
        {
          // statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => SellerMangament()));
        }
        break;

      case 'device':
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => DeviceMangament()));
        }
        break;

      default:
        {
          throw new Exception();
        }
        break;
    }
  }
}
