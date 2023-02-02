import 'package:flutter/material.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/table.dart';

class BillPart extends StatelessWidget {
  BillPart();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: height * 0.3,
              width: double.infinity,
              child: MenuDataTable(['Name','Price','Quantity'],[['tea','20','1'],['coffe','30','1']]),

            ),
            SizedBox(
              height: height * 0.4,
            ),
            SizedBox(
              height: 0.2 * height,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      option_Button(Icon(Icons.payment), 'Pay'),
                      option_Button(Icon(Icons.payments), ' Fast Pay'),
                      option_Button(Icon(Icons.add_box), 'Different Item'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      option_Button(Icon(Icons.delete), 'Remove'),
                      option_Button(Icon(Icons.search), ' Bar-Code'),
                      option_Button(Icon(Icons.cancel), 'Cancel'),
                    ],
                  )
                ],
              ),
            )
          ]),
    );
  }

  Expanded option_Button(Icon icon, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: icon,
          label: Text(label),
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Colors.grey.withOpacity(0.6)),
            shadowColor: MaterialStateProperty.all(Colors.grey),
            elevation: MaterialStateProperty.all(5),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
            //padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // overlayColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
    );
  }
}
