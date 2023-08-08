import 'package:flutter/material.dart';

import '../../../helpers/paragraph_format.dart';
import '../../../models/article_info/children_model/brief/brief.dart';

class BriefWidget extends StatelessWidget {
  const  BriefWidget({Key? key, this.brief, required this.sectionColor}) : super(key: key);
  final Brief? brief;
  final Color sectionColor;
  @override
  Widget build(BuildContext context) {
    if (brief == null || brief?.blocks == null) {
      return const SizedBox.shrink();
    }
    ParagraphFormat paragraphFormat = ParagraphFormat();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: sectionColor,
      child: Column(
          children: brief!.blocks!.map((block) {
            return paragraphFormat.parseTheTextToHtmlWidget(block.data!['text'],
                color: Colors.white, fontSize: 17);
          }).toList()),
    );
  }
}