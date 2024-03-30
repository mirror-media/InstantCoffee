import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/models/paragraph.dart';


import '../../../core/values/text_style.dart';

class HtmlTextWidget extends StatelessWidget {
  final String tag;
  final Map<String, String>? customStyle;
  final Paragraph paragraph;

  const HtmlTextWidget(
      {Key? key, required this.tag, this.customStyle, required this.paragraph})
      : super(key: key);

  factory HtmlTextWidget.h1(Paragraph paragraph) {
    return HtmlTextWidget(
        paragraph: paragraph, tag: 'h1', customStyle: CustomTextStyle.h1);
  }

  factory HtmlTextWidget.h2(Paragraph paragraph) {
    return HtmlTextWidget(
        paragraph: paragraph, tag: 'h2', customStyle: CustomTextStyle.h2);
  }

  factory HtmlTextWidget.h3(Paragraph paragraph) {
    return HtmlTextWidget(
        paragraph: paragraph, tag: 'h3', customStyle: CustomTextStyle.h3);
  }

  factory HtmlTextWidget.h4(Paragraph paragraph) {
    return HtmlTextWidget(
        paragraph: paragraph, tag: 'h4', customStyle: CustomTextStyle.h4);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget('<$tag>${paragraph.contents![0].data!}</$tag>',
        customStylesBuilder: (e) => customStyle);
  }
}
