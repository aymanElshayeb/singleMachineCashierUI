import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Locale/locale_bloc_bloc.dart';

void main() {
  runApp(MaterialApp(
    home: LangPopup(),
  ));
}

class LangPopup extends StatefulWidget {
  @override
  State<LangPopup> createState() => _LangPopupState();
}

class _LangPopupState extends State<LangPopup> {
  List<String> listitems = [
    "English",
    "German",
  ];
  String selectval = "English";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.2,
      width: width * 0.1,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.topCenter,
      child: DropdownButton(
        value: selectval,
        onChanged: (value) {
          if (value == 'English') {
            BlocProvider.of<LocaleBlocBloc>(context)
                .add(LoadLanguage(locale: Locale('en')));
          } else {
            BlocProvider.of<LocaleBlocBloc>(context)
                .add(LoadLanguage(locale: Locale('de')));
          }

          setState(() {
            selectval = value.toString();
          });
        },
        items: listitems.map((itemone) {
          return DropdownMenuItem(
              value: itemone,
              child: Text(
                itemone,
                style: TextStyle(fontSize: width * 0.01),
              ));
        }).toList(),
      ),
    );
  }
}
