import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/youtube_widget/youtube_widget_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWidget extends GetView<YoutubeWidgetController> {
  final Paragraph paragraph;

  const YoutubeWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(YoutubeWidgetController());
    final youtubeId = paragraph.contents![0].data;
    final description = paragraph.contents![0].description;
    return youtubeId != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final isVisible = controller.rxIsViable.value;
                return AnimatedOpacity(
                  opacity: isVisible ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: Get.width,
                    height: Get.width / 16 * 9,
                    child: WebView(
                      initialUrl: 'https://www.youtube.com/embed/$youtubeId',
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (e) {
                        controller.rxIsViable.value = false;
                      },
                    ),
                  ),
                );
              }),
              if (description != null && description != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
            ],
          )
        : const SizedBox.shrink();
  }
}
