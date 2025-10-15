// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//
// class IYoutubeWidget extends StatefulWidget {
//   const IYoutubeWidget({Key? key}) : super(key: key);
//
//   @override
//   State<IYoutubeWidget> createState() => _IYoutubeWidgetState();
// }
//
// class _IYoutubeWidgetState extends State<IYoutubeWidget> {
//
//
//   YoutubePlayerController? controller;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller = YoutubePlayerController.fromVideoId(
//       videoId: 'yykva2-Y9XE',
//       autoPlay: false,
//       params: const YoutubePlayerParams(showFullscreenButton: true),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayer(
//       controller: controller!,
//       aspectRatio: 16 / 9,
//     );
//   }
// }
