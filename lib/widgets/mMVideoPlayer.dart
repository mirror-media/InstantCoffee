import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
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

  MMVideoPlayer({
    Key key,
    @required this.videourl,
    @required this.aspectRatio,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
  }) : super(key: key);

  @override
  _MMVideoPlayerState createState() => _MMVideoPlayerState();
}

class _MMVideoPlayerState extends State<MMVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    _configVideoPlayer();
    super.initState();
  }

  void _configVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.videourl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRatio,
      autoInitialize: true,
      customControls: MaterialControls(),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}