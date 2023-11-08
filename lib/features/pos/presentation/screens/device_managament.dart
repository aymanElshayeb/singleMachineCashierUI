import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/handle_printer_and_drawer.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/reusable_dropdown.dart';

class DeviceMangament extends StatefulWidget {
  final List<Printer> printers;
  const DeviceMangament({Key? key, required this.printers}) : super(key: key);

  @override
  State<DeviceMangament> createState() => _DeviceMangamentState();
}

class _DeviceMangamentState extends State<DeviceMangament> {
  @override
  void initState() {
    super.initState();
    selectedMethod = widget.printers[0].name;
  }

  String? selectedMethod;
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

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
                  width: 270,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: ReusableDropdown(
                    items: widget.printers.map((e) => e.name).toList(),
                    selectedValue: selectedMethod!,
                    onChanged: (newValue) async {
                      setState(() {
                        selectedMethod = newValue!;
                      });
                      await updatePrinterUrl(selectedMethod!);
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      HandlePrinterAndDrawer.openDrawer();
                    },
                    child: Text(AppLocalizations.of(context)!.test))
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> updatePrinterUrl(String newUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_url', newUrl);
  }
}
