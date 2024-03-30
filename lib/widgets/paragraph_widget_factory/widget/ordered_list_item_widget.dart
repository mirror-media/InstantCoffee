import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/models/paragraph.dart';

class OrderedListItemWidget extends StatelessWidget {
  final Paragraph paragraph;

  const OrderedListItemWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataList = paragraph.contents[0].listData;
    return dataList != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: HtmlWidget(
                      dataList[index],
                      textStyle: const TextStyle(
                        fontSize: 14,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              );
            })
        : const SizedBox.shrink();
  }
}
