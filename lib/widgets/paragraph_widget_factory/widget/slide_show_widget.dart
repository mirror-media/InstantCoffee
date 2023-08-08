import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SlideShowWidget extends StatelessWidget {
  final Paragraph paragraph;

  const SlideShowWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    final delaySec = paragraph.contents![0].slideShowDelay;
    return paragraph.contents?[0].slideShowImageList != null
        ? Stack(
            children: [
              CarouselSlider(
                items: paragraph.contents![0].slideShowImageList!
                    .map((imageCollection) {
                  return CachedNetworkImage(
                    imageUrl: imageCollection.original!,
                    width: Get.width,
                    placeholder: (context, url) => Container(
                      height: Get.width / 16 * 9,
                      width: Get.width,
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: Get.width / 16 * 9,
                      width: Get.width,
                      color: Colors.grey,
                      child: const Icon(Icons.error),
                    ),
                    fit: BoxFit.cover,
                  );
                }).toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: delaySec ?? 5),
                  viewportFraction: 1,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: (Get.width / 32 * 9 - 18)),
                  Row(
                    children: [
                      InkWell(
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 36,
                          ),
                          onTap: () => carouselController.previousPage()),
                      const Spacer(),
                      InkWell(
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 36,
                          ),
                          onTap: () => carouselController.nextPage()),
                    ],
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
