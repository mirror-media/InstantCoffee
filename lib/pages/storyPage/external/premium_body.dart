import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/external_story.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';
import 'package:readr_app/helpers/paragraph_format.dart';

import '../../../core/values/string.dart';

class PremiumBody extends StatelessWidget {
  final ExternalStory externalStory;

  const PremiumBody({Key? key, required this.externalStory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    ParagraphFormat paragraphFormat = ParagraphFormat();

    return ListView(padding: const EdgeInsets.only(top: 24), children: [
      _buildCategoryText(),
      const SizedBox(height: 8),
      _buildStoryTitle(externalStory.title ?? StringDefault.valueNullDefault),
      const SizedBox(height: 32),
      _buildHeroImage(width, height,
          externalStory.heroImage ?? StringDefault.valueNullDefault),
      const SizedBox(height: 32),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(left: 2),
        color: const Color.fromRGBO(5, 79, 119, 1),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeTile(
                  '發布時間',
                  externalStory.publishedDate ??
                      StringDefault.valueNullDefault),
              const SizedBox(
                height: 16,
              ),
              _buildAuthors(
                  externalStory.extendByLine ?? StringDefault.valueNullDefault),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: paragraphFormat.parseTheTextToHtmlWidget(
        externalStory.content ?? StringDefault.valueNullDefault,
        fontSize: 18,
        ),
      ),
      const SizedBox(height: 24),
    ]);
  }

  _buildCategoryText() {
    return const Center(
      child: Text(
        '時事',
        style: TextStyle(fontSize: 15, color: appColor),
      ),
    );
  }

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'PingFang TC',
          fontSize: 28,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHeroImage(double width, double height, String imageUrl) {
    return CustomCachedNetworkImage(
        height: height, width: width, imageUrl: imageUrl);
  }

  Widget _buildTimeTile(String title, String time) {
    if (time == '' || time == ' ') {
      return Container();
    }
    return Row(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(width: 8),
        Text(
          time.formattedTaipeiDateTime() ?? StringDefault.valueNullDefault,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthors(String extendByline) {
    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: Colors.black,
        width: 1,
        height: 16,
      ),
    );

    return Row(
      children: [
        const Text("文", style: TextStyle(color: Colors.black54, fontSize: 15)),
        // VerticalDivider
        myVerticalDivider,
        Text(
          extendByline,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
