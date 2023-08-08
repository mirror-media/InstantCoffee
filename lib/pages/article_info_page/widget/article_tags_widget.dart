import 'package:flutter/material.dart';

import '../../../core/values/string.dart';
import '../../../helpers/data_constants.dart';
import '../../../models/article_info/children_model/article_tag.dart';

class ArticleTagsWidget extends StatelessWidget {
  final List<ArticleTag>? articleTags;

  const ArticleTagsWidget({Key? key, this.articleTags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return articleTags == null
        ? const SizedBox.shrink()
        : Wrap(
            runSpacing: 8,
            spacing: 8,
            children: articleTags!.map((articleTag) {
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(color: appColor),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    articleTag.name ?? StringDefault.valueNullDefault,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: appColor),
                    strutStyle: const StrutStyle(
                        forceStrutHeight: true, fontSize: 13, height: 1.5),
                  ),
                ),
                // onTap: () => RouteGenerator.navigateToTagPage(articleTags[i]),
              );
            }).toList(),
          );
  }
}
