import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page_controller.dart';

class PodcastPage extends GetView<PodcastPageController> {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<PodcastPageController>()) {
      Get.delete<PodcastPageController>();
    }
    Get.put(PodcastPageController());
    return Column(
      children: [
        Text('hello world'),
        ElevatedButton(
          onPressed: () {
            controller.testButtonClick();
          },
          child: Text('test'),
        )
      ],
    );
  }
}
