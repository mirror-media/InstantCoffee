import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({Key? key, required this.data}) : super(key: key);
  final List<List<String>> data;

  @override
  Widget build(BuildContext context) {
    final tableData = data
        .map(
          (rowList) => TableRow(
            children: rowList
                .map(
                  (row) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HtmlWidget(row),
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    return Table(
      border: TableBorder.all(
          color: const Color(0xFFE2E8F0), width: 1.0, style: BorderStyle.solid),
      children: tableData,
    );
  }
}
