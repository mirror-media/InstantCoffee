import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/external_story.dart';

class DefaultBody extends StatelessWidget {
  final ExternalStory externalStory;

  const DefaultBody({Key? key, required this.externalStory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    return ListView(children: [
      _buildHeroImage(width, height,
          externalStory.heroImage ?? StringDefault.valueNullDefault),
      const SizedBox(height: 32),
      _buildCategoryAndPublishedDate(
          externalStory.publishedDate ?? StringDefault.valueNullDefault),
      const SizedBox(height: 8),
      _buildStoryTitle(externalStory.title ?? StringDefault.valueNullDefault),
      const SizedBox(height: 8),
      _buildAuthors(
          externalStory.extendByLine ?? StringDefault.valueNullDefault),
      const SizedBox(height: 16),
      HtmlWidget(
        externalStory.content ?? StringDefault.valueNullDefault,
        customStylesBuilder: (element) {
          if (element.localName == 'a') {
            return {'padding': '0px 0px 0px 0px'};
          }
          return {'padding': '0px 16px 0px 16px'};
        },
      ),
      const SizedBox(height: 16),
    ]);
  }

  Widget _buildHeroImage(double width, double height, String imageUrl) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        color: Colors.grey,
        child: const Icon(Icons.error),
      ),
      fit: BoxFit.cover,
    );
  }

  Widget _buildCategory() {
    return Row(
      children: [
        Container(width: 10, height: 20, color: appColor),
        const SizedBox(width: 10),
        const Text(
          '時事',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildCategoryAndPublishedDate(String publishedDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(),
          Text(
            publishedDate.formattedTaipeiDateTime() ?? StringDefault.valueNullDefault,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600], /*fontStyle: FontStyle.italic,*/
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Open Sans', fontSize: 28),
      ),
    );
  }

  Widget _buildAuthors(String extendByline) {
    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: Colors.black,
        width: 1,
        height: 16,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: [
        const Text("文"),
        myVerticalDivider,
        Text(extendByline),
      ]),
    );
  }
}
