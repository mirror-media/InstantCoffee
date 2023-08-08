import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/extensions/duration_extension.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';

import 'audio_player_controller.dart';

class AudioPlayerWidget extends GetView<AudioPlayerController> {
  final Paragraph paragraph;

  const AudioPlayerWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final description = paragraph.contents![0].description;
    final audioUrl = paragraph.contents![0].data;
    Get.put(AudioPlayerController(audioUrl));
    final Color audioColor = Colors.orange.shade800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (description != null)
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: Get.width,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    // height: 1.8,
                  ),
                ),
              ),
            ),
          ),
        Container(
          color: Colors.grey[300],
          child: Row(
            children: [
              const SizedBox(width: 8),
              InkWell(
                child: Obx(() {
                  final state = controller.rxCurrentAudioState.value;
                  return Icon(
                    state == PlayerState.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: audioColor,
                    size: 36,
                  );
                }),
                onTap: () => controller.playPauseButtonClick(),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final sliderValue = controller.rxSlideValue.value;
                    final audioDuration = controller
                        .rxAudioDuration.value?.inMilliseconds
                        .toDouble();
                    return Slider(
                      min: 0.0,
                      max: audioDuration ?? 0.0,
                      value: sliderValue,
                      activeColor: audioColor,
                      inactiveColor: Colors.black,
                      onChanged: controller.sliderChangeEvent,
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, left: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          final positionValue = controller
                              .rxCurrentDuration.value
                              ?.formatDuration();
                          return Text(
                            positionValue ?? StringDefault.valueNullDefault,
                            style: TextStyle(
                              color: audioColor,
                            ),
                          );
                        }),
                        Obx(() {
                          final durationValue = controller.rxAudioDuration.value
                              ?.formatDuration();
                          return Text(
                            durationValue ?? StringDefault.valueNullDefault,
                            style: TextStyle(
                              color: audioColor,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
