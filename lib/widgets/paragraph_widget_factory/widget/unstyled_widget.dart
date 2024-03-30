import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/models/paragraph.dart';



class UnStyledWidget extends StatelessWidget {
  final Paragraph paragraph;
  const UnStyledWidget(this.paragraph, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      '<div style="text-align: start">${paragraph.contents?[0].data!}</div>',
      textStyle: const TextStyle(
        fontSize: 20,
        height: 1.8,
      ),
    );
  }
}