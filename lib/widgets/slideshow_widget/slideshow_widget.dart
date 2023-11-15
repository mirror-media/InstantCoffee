import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/widgets/slideshow_widget/slideshow_controller.dart';

class SlideShowWidget extends StatelessWidget {
  const SlideShowWidget({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    final SlideShowController controller = Get.find(tag: id);
    return controller.rxContentList.isNotEmpty
        ? Stack(
            children: [
              Column(
                children: [
                  CarouselSlider(
                    items: controller.rxContentList.map((content) {
                      return CachedNetworkImage(
                        imageUrl: content.data ?? '',
                        width: Get.width,
                        placeholder: (context, url) => Container(
                          height: Get.width / (content.aspectRatio ?? 16 * 9),
                          width: Get.width,
                          color: Colors.grey,
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: Get.width / (content.aspectRatio ?? 16 * 9),
                          width: Get.width,
                          color: Colors.grey,
                          child: const Icon(Icons.error),
                        ),
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                    carouselController: controller.carouselController,
                    options: controller.option!,
                  ),
                  Obx(() {
                    final description = controller.rxnDescription.value;
                    return description != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              const Divider(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                thickness: 1,
                                height: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, right: 20, left: 20),
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink();
                  })
                ],
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
                          onTap: () =>
                              controller.carouselController.previousPage()),
                      const Spacer(),
                      InkWell(
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 36,
                          ),
                          onTap: () =>
                              controller.carouselController.nextPage()),
                    ],
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
