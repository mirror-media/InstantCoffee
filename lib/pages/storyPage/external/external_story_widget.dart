import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/pages/storyPage/external/default_body.dart';
import 'package:readr_app/pages/storyPage/external/external_story_controller.dart';
import 'package:readr_app/pages/storyPage/external/premium_body.dart';

class ExternalStoryWidget extends GetView<ExternalStoryController> {
  const ExternalStoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageStatus = controller.rxPageStatus.value;
      final isPremium = controller.rxIsPremium.value;
      final externalStory = controller.rxExternalStory.value;
      if (pageStatus == PageStatus.loading) {
        return _loadingWidget();
      } else {
        if (externalStory == null) {
          return Container();
        }
        return isPremium
            ? PremiumBody(externalStory: externalStory)
            : DefaultBody(externalStory: externalStory);
      }
    });
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
