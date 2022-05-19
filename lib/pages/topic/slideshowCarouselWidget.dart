import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/topic.dart';

class SlideshowCarouselWidget extends StatefulWidget {
  final Topic topic;
  SlideshowCarouselWidget(this.topic, {Key? key}) : super(key: key);

  @override
  State<SlideshowCarouselWidget> createState() =>
      _SlideshowCarouselWidgetState();
}

class _SlideshowCarouselWidgetState extends State<SlideshowCarouselWidget> {
  final CarouselController _carouselController = CarouselController();
  final CarouselOptions _options = CarouselOptions(
    viewportFraction: 1.0,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 6),
    enlargeCenterPage: true,
    onPageChanged: (index, reason) {},
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.topic.ogImageUrl),
          fit: BoxFit.contain,
        ),
        color: Colors.black,
      ),
      child: _carouselWidget(),
    );
  }

  Widget _carouselWidget() {
    if (widget.topic.slideshowImageUrlList == null ||
        widget.topic.slideshowImageUrlList!.isEmpty) {
      return Container();
    }
    double imageWidth = Get.width / 1.5;
    double imageHeight = imageWidth / (16 / 9);

    return Stack(
      children: [
        CarouselSlider(
          items: _buildImageList(),
          carouselController: _carouselController,
          options: _options,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(35, imageHeight / 2 + 15, 0, 0),
          child: InkWell(
            child: Container(
              color: Colors.white60,
              width: 30,
              height: 40,
              padding: const EdgeInsets.only(left: 8),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_back_ios,
                color: appColor,
              ),
            ),
            onTap: () {
              _carouselController.previousPage();
            },
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(0, imageHeight / 2 + 15, 35, 0),
          child: InkWell(
            child: Container(
              color: Colors.white60,
              width: 30,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: appColor,
              ),
            ),
            onTap: () {
              _carouselController.nextPage();
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildImageList() {
    return widget.topic.slideshowImageUrlList!
        .map((item) => _buildImageItem(item))
        .toList();
  }

  Widget _buildImageItem(String imageUrl) {
    double imageWidth = Get.width / 1.5;
    double imageHeight = imageWidth / (16 / 9);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: imageWidth,
      height: imageHeight,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      errorWidget: (context, url, error) => Container(),
    );
  }
}
