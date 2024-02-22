import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/pages/storyPage/external/external_story_controller.dart';
import 'package:readr_app/pages/storyPage/external/external_story_widget.dart';
import 'package:share_plus/share_plus.dart';

class ExternalStoryPage extends GetView<ExternalStoryController> {
  final String slug;
  final bool isPremiumMode;

  const ExternalStoryPage(
      {Key? key, required this.slug, required this.isPremiumMode})
      : super(key: key);

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
            icon: const Icon(Icons.share),
            tooltip: 'share',
            onPressed: () {
              Share.share(
                  '${Environment().config.mirrorMediaDomain}/external/$slug');
            },
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
