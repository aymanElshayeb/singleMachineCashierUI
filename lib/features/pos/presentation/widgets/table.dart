import 'package:flutter/material.dart';

class MenuDataTable extends StatelessWidget {
  final List<String> cols;
  final List<List<String>> rows;

  MenuDataTable(this.cols, this.rows);
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith(
          (states) => Colors.grey.withOpacity(0.4)),
      columns: [
        for (var item in cols)
          DataColumn(
              label: Text(item,
                  style: TextStyle(
                      fontSize: screenwidth * 0.009,
                      fontWeight: FontWeight.bold))),
      ],
      rows: [
        for (var items in rows)
          DataRow(cells: [
            for (var item in items)
              DataCell(Container(
                width: screenwidth * 0.09,
                child: Text(
                  item,
                  style: TextStyle(fontSize: screenwidth * 0.01),
                ),
              )),
          ]),
      ],
    );
  }
}
