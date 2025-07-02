import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/storyPage/external/external_story_controller.dart';
import 'package:readr_app/pages/storyPage/external/external_story_widget.dart';

class ExternalStoryPage extends GetView<ExternalStoryController> {
  final String slug;
  final bool isPremiumMode;

  ExternalStoryPage({Key? key, required this.slug, required this.isPremiumMode})
      : super(key: key);

  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            key: _shareButtonKey,
            icon: const Icon(Icons.share),
            tooltip: 'share',
            onPressed: () =>
                controller.shareStory(shareButtonKey: _shareButtonKey),
          )
        ],
      ),
      body: Obx(() {
        final slug = controller.rxnSlug.value;
        return slug != null
            ? const ExternalStoryWidget()
            : const SizedBox.shrink();
      }),
    );
  }
}
