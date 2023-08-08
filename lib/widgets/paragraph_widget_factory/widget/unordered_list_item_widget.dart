import 'package:flutter/material.dart';

import '../../../helpers/data_constants.dart';
import '../../../models/article_info/children_model/paragraph_model/paragraph.dart';

class UnorderedListItemWidget extends StatelessWidget {
  final Paragraph paragraph;

  const UnorderedListItemWidget(this.paragraph, {Key? key}) : super(key: key);

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: appColor,
                        shape: BoxShape.circle,
                      ),
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
