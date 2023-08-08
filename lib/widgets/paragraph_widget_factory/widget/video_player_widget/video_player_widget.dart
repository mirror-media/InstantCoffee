import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/video_player_widget/video_player_controller.dart';

class VideoPlayerWidget extends GetView<VideoPlayerWidgetController> {
  final Paragraph paragraph;

  const VideoPlayerWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VideoPlayerWidgetController(paragraph.contents![0].data));
    return Obx(() {
      final isInitialization = controller.rxIsInitialization.value;
      return isInitialization
          ? Chewie(
              controller: controller.chewieController!,
            )
          : Text('wait');
    });
  }
}
