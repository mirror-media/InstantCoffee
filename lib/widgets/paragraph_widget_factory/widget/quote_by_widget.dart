import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import '../../../helpers/data_constants.dart';
import 'dart:math' as math;

class QuoteByWidget extends StatelessWidget {
  final Paragraph paragraph;

  const QuoteByWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String quote = paragraph.contents![0].data??StringDefault.valueNullDefault;
    String quoteBy =paragraph.contents![0].description??StringDefault.valueNullDefault;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: appColor,
                  thickness: 2,
                  height: 2,
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: const Icon(
                  Icons.format_quote,
                  size: 40,
                  color: Color.fromRGBO(5, 79, 119, 1),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              const Expanded(
                child: Divider(
                  color: appColor,
                  thickness: 2,
                  height: 2,
                ),
              ),
            ],
          ),
          Text(
            quote,
            style: const TextStyle(
              color: Color.fromRGBO(5, 79, 119, 1),
              fontSize: 17,
              height: 1.8,
            ),
          ),
          if (quoteBy != '') ...[
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '⎯ $quoteBy',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.8,
                  color: Color.fromRGBO(5, 79, 119, 1),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
