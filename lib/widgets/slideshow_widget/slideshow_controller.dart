import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/content.dart';

class SlideShowController extends GetxController {
  final RxList<Content> rxContentList = RxList();
  final RxnString rxnDescription = RxnString();

  final CarouselSliderController carouselController =
      CarouselSliderController();
  CarouselOptions? option;

  SlideShowController(List<Content> contentList) {
    rxContentList.value = contentList;
  }

  @override
  void onInit() {
    super.onInit();
    pageChange(0);
    option = CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          pageChange(index);
        });
  }

  void pageChange(int index) {
    rxnDescription.value = rxContentList[index].description;
  }
}
