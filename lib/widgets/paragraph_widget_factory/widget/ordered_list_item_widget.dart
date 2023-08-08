import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';

class OrderedListItemWidget extends StatelessWidget {
  final Paragraph paragraph;

  const OrderedListItemWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataList = paragraph.contents![0].itemList;
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
                      fontSize: 20,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      dataList[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            })
        : const SizedBox.shrink();
  }
}
