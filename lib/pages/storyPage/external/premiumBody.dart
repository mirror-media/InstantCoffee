import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/models/externalStory.dart';
import 'package:readr_app/pages/storyPage/external/externalEmbeddedCodeWidget.dart';

class PremiumBody extends StatelessWidget {
  final ExternalStory externalStory;
  const PremiumBody(
      {Key? key, required this.externalStory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    return ListView(
      padding: const EdgeInsets.only(top: 24),
      children: [
        _buildCategoryText(),
        const SizedBox(height: 8),
        _buildStoryTitle(externalStory.title),
        const SizedBox(height: 32),
        _buildHeroImage(width, height , externalStory.heroImage),
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
                _buildTimeTile('發布時間', externalStory.publishedDate),
                const SizedBox(
                  height: 16,
                ),
                _buildAuthors(externalStory.extendByLine),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ExternalEmbeddedCodeWidget(embeddedCode: externalStory.content)
      ]
    );
  }

  _buildCategoryText() {
    return Center(
      child: Text(
        '時事',
        style: const TextStyle(fontSize: 15, color: appColor),
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

  Widget _buildHeroImage(
    double width,
    double height,
    String imageUrl
  ) {
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
        child: Icon(Icons.error),
      ),
      fit: BoxFit.cover,
    );
  }
  
  Widget _buildTimeTile(String title, String time){
    if(time == '' || time == ' '){
      return Container();
    }
    DateTimeFormat dateTimeFormat = DateTimeFormat();
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(width: 8),
        Text(
            dateTimeFormat.changeDatabaseStringToDisplayString(
                time, 'yyyy.MM.dd HH:mm'),
            style: TextStyle(
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
        Text("文", style: const TextStyle(color: Colors.black54, fontSize: 15)),
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