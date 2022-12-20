import 'package:flutter/material.dart';
class MenuDataTable extends StatelessWidget {
  final List<String> cols;
  final List<List<String>> rows;

  MenuDataTable(this.cols, this.rows);
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith(
          (states) => Colors.grey.withOpacity(0.4)),
      columns:  [
        for(var item in cols )
          DataColumn(
            label: Text(item,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ],
      rows:  [
        for(var items in rows )
        DataRow(cells: [
          for(var item in items )
          DataCell(Text(item)),
        ]),
      ],
    );
  }
}
