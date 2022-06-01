import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/adHelper.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';

class CarouselDisplayWidget extends StatelessWidget {
  final Record record;
  final double width;
  final double aspectRatio;
  CarouselDisplayWidget({
    required this.record,
    required this.width,
    this.aspectRatio = 16 / 9,
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
        if (!context.read<MemberBloc>().state.isPremium) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }
        RouteGenerator.navigateToStory(
          record.slug,
          isMemberCheck: record.isMemberCheck,
          url: record.url,
        );
      },
    );
  }

  Widget _displayImage(double width, Record record) {
    return CachedNetworkImage(
      height: width / aspectRatio,
      width: width,
      imageUrl: record.photoUrl,
      placeholder: (context, url) => Container(
        height: width / aspectRatio,
        width: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: width / aspectRatio,
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
      height: width / aspectRatio / 3,
      color: Colors.black.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          height: 56,
          child: Center(
            child: AutoSizeText(
              record.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              minFontSize: 20,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
