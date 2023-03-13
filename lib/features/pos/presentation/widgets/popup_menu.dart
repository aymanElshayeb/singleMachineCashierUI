import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/user_permission_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/user/user_bloc.dart';
import '../screens/device_managament.dart';
import '../screens/seller_managament.dart';

// This is the type used by the popup menu below.
enum SampleItem { itemOne, itemTwo, itemThree, itemFour, itemFive }

class PopupMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.2,
      width: width * 0.1,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: PopupMenuButton<SampleItem>(
        initialValue: selectedMenu,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context)!.office,
              style: TextStyle(
                  fontSize: 0.011 * width, fontStyle: FontStyle.normal),
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
                title: Text(AppLocalizations.of(context)!.sellermanagement),
                onTap: () => gotoPage('seller')),
          ),
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo,
            child: ListTile(
              leading: const Icon(Icons.device_hub),
              title: Text(AppLocalizations.of(context)!.devicemanagement),
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
          final currentBloc = context.read<UserBloc>();
          if (currentBloc.state.currentUser.role == 'ADMIN') {
            Navigator.push(context,
                CupertinoPageRoute(builder: (redContext) => SellerMangament()));
          } else {
            showDialog(
                context: context,
                builder: (((cc) {
                  return BlocProvider.value(
                    value: currentBloc,
                    child: UserPermissionDialog(),
                  );
                })));
          }
        }
        break;

      case 'device':
        {
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
