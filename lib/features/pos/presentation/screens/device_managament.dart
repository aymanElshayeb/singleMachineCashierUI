import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceMangament extends StatelessWidget {
  const DeviceMangament({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    const selectedMethod = 'printer1';
    const selectedMethod2 = 'drawer1';
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.devicemanagement)),
      body: Center(
        child: Container(
          width: screenwidth * 0.7,
          height: screenheight * 0.9,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.all(8),
              child: Text(
                AppLocalizations.of(context)!.printersettings,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: DropdownButton(
                    items: ["printer1", "printer2"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      debugPrint(val);
                    },
                    value: selectedMethod,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.test))
              ],
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.all(8),
              child: Text(
                AppLocalizations.of(context)!.drawersettings,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: DropdownButton(
                    items: ["drawer1", "drawer2"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      debugPrint(val);
                    },
                    value: selectedMethod2,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.test))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
