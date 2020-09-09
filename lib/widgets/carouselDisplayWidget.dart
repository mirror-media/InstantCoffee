import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/pages/storyPage.dart';

class CarouselDisplayWidget extends StatelessWidget {
  final Record record;
  final double width;
  CarouselDisplayWidget({
    @required this.record,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          _displayImage(width, record),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _displayTag(record),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _displayTitle(record),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(slug: record.slug)));
      },
    );
  }

  Widget _displayImage(double width, Record record) {
    return CachedNetworkImage(
      height: width / 16 * 9,
      width: width,
      imageUrl: record.photoUrl,
      placeholder: (context, url) => Container(
        height: width / 16 * 9,
        width: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: width / 16 * 9,
        width: width,
        color: Colors.grey,
        child: Icon(Icons.error),
      ),
      fit: BoxFit.cover,
    );
  }

  Widget _displayTag(Record record) {
    return Container(
      decoration: new BoxDecoration(
        color: appColor,
        borderRadius: new BorderRadius.circular((20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Text(
          '編輯精選',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _displayTitle(Record record) {
    return Container(
      height: width / 16 * 9 / 3,
      color: Colors.black.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Center(
          child: Container(
            height: 56,
            child: Center(
              child: Text(
                record.title.length > 35
                    ? record.title.substring(0, 35) + ' ...'
                    : record.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
