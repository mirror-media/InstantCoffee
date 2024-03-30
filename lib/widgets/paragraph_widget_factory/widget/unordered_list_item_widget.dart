import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/models/paragraph.dart';

import '../../../helpers/data_constants.dart';

class UnorderedListItemWidget extends StatelessWidget {
  final Paragraph paragraph;

  const UnorderedListItemWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataList = paragraph.contents;

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
                    padding: const EdgeInsets.fromLTRB(0,10, 0, 8),
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
                    child: HtmlWidget(
                      dataList[index].data??'',
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            })
        : const SizedBox.shrink();
  }
}
