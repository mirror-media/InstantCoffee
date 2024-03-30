import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/video_player_widget/video_player_controller.dart';

class VideoPlayerWidget extends GetView<VideoPlayerWidgetController> {
  final Paragraph paragraph;

  const VideoPlayerWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoPlayerWidgetController controller = Get.put(
        VideoPlayerWidgetController(paragraph.contents[0].data),
        tag: paragraph.contents[0].data);

    return Obx(() {
      final isInitialization = controller.rxIsInitialization.value;
      return isInitialization
          ? AspectRatio(
            aspectRatio: controller.chewieController?.aspectRatio?? 16/9,
            child: Chewie(
              controller: controller.chewieController!,
            ),
          )
          : const SizedBox.shrink();
    });
  }
}
