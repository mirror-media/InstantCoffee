import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:video_player/video_player.dart';

class MMVideoPlayer extends StatefulWidget {
  /// The baseUrl of the video
  final String videourl;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  const MMVideoPlayer({
    Key? key,
    required this.videourl,
    required this.aspectRatio,
    this.autoPlay = false,
    this.startAt = Duration.zero,
    this.looping = false,
  }) : super(key: key);

  @override
  _MMVideoPlayerState createState() => _MMVideoPlayerState();
}

class _MMVideoPlayerState extends State<MMVideoPlayer>
    with AutomaticKeepAliveClientMixin, Logger {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<bool> _configChewieFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _configChewieFuture = _configVideoPlayer();
    super.initState();
  }

  Future<bool> _configVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videourl);
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        customControls: const MaterialControls(),
      );
    } catch (e) {
      debugLog('Video player error: $e');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<bool>(
        initialData: false,
        future: _configChewieFuture,
        builder: (context, snapshot) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (!snapshot.data!) {
              return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth / widget.aspectRatio,
                  child: const Center(child: CircularProgressIndicator()));
            }

            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth /
                  _videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: _chewieController,
              ),
            );
          });
        });
  }
}
