import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MMVideoPlayer extends StatefulWidget {
  /// The baseUrl of the video
  final String videourl;

  /// Initialize the Video on Startup. This will prep the video for playback.
  final bool autoInitialize;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// Whether or not to show the controls
  final bool showControls;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  /// Play video directly in fullscreen
  final bool fullscreenByDefault;

  MMVideoPlayer({
    Key key,
    @required this.videourl,
    @required this.aspectRatio,
    this.autoInitialize = true,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.showControls = true,
    this.fullscreenByDefault = false,
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
      startAt: widget.startAt,
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      showControls: widget.showControls,
      fullScreenByDefault: widget.fullscreenByDefault,
      autoInitialize: widget.autoInitialize,
      allowFullScreen: true,
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
    return Center(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}