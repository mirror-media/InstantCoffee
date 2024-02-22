import 'package:flutter/material.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveStreamWidget extends StatelessWidget {
  final String title;
  final YoutubePlayerController? ytPlayer;

  const LiveStreamWidget(
      {Key? key, required this.title, required this.ytPlayer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            width: 163,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: appColor,
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white),
              ),
            )),
        const SizedBox(height: 24),
        if (ytPlayer != null)
          YoutubePlayer(
            controller: ytPlayer!,
            showVideoProgressIndicator: false,
            bottomActions: const [],
          ),
      ],
    );
  }
}
