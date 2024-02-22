import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/firebase_analytics_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/newsMarquee/marquee_widget.dart';

class NewsMarqueeWidget extends StatefulWidget {
  final List<Record> recordList;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const NewsMarqueeWidget({
    required this.recordList,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<NewsMarqueeWidget> {
  final CarouselController _carouselController = CarouselController();
  final CarouselOptions _options = CarouselOptions(
    scrollPhysics: const NeverScrollableScrollPhysics(),
    height: 48,
    viewportFraction: 1,
    scrollDirection: Axis.vertical,
    initialPage: 0,
    autoPlay: true,
    autoPlayInterval: const Duration(milliseconds: 5000),
    enableInfiniteScroll: false,
    enlargeCenterPage: false,
    onPageChanged: (index, reason) {},
  );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return CarouselSlider(
      items: _buildList(width, widget.recordList),
      carouselController: _carouselController,
      options: _options,
    );
  }

  List<Widget> _buildList(double width, List<Record> recordList) {
    List<Widget> resultList = [];
    for (int i = 0; i < recordList.length; i++) {
      resultList.add(InkWell(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarqueeWidget(
                animationDuration: const Duration(milliseconds: 4000),
                child: Text(
                  recordList[i].title ?? StringDefault.valueNullDefault,
                  style: const TextStyle(fontSize: 18, color: appColor),
                ),
              ),
            ),
          ),
          onTap: () {
            FirebaseAnalyticsHelper.logNewsMarqueeOpen(
                slug: recordList[i].slug,
                title: recordList[i].title ?? StringDefault.valueNullDefault);
            if (!context.read<MemberBloc>().state.isPremium) {
              AdHelper adHelper = AdHelper();
              adHelper.checkToShowInterstitialAd();
            }
            RouteGenerator.navigateToStory(
              recordList[i].slug,
              isMemberCheck: recordList[i].isMemberCheck,
              url: recordList[i].url,
            );
          }));
    }

    return resultList;
  }
}
