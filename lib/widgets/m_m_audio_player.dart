import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/date_time_format.dart';

class MMAudioPlayer extends StatefulWidget {
  /// The baseUrl of the audio
  final String audioUrl;

  /// The title of audio
  final String? title;

  /// The description of audio
  final String? description;
  const MMAudioPlayer({
    required this.audioUrl,
    this.title,
    this.description,
  });

  @override
  _MMAudioPlayerState createState() => _MMAudioPlayerState();
}

class _MMAudioPlayerState extends State<MMAudioPlayer>
    with AutomaticKeepAliveClientMixin {
  final Color _audioColor = Colors.orange.shade800;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool get _checkIsPlaying => !(_audioPlayer.state == PlayerState.completed ||
      _audioPlayer.state == PlayerState.stopped ||
      _audioPlayer.state == PlayerState.paused);
  Duration _duration = const Duration();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  void _initAudioPlayer() async {
    await _audioPlayer.setSourceUrl(widget.audioUrl);
  }

  _start() async {
    try {
      _duration = await _audioPlayer.getDuration() ?? const Duration();
      if (_duration.inMilliseconds < 0) {
        _duration = const Duration();
      }
    } catch (e) {
      _duration = const Duration();
    }

    await _audioPlayer.play(UrlSource(widget.audioUrl));
  }

  _play() async {
    await _audioPlayer.resume();
  }

  _pause() async {
    await _audioPlayer.pause();
  }

  _playAndPause() {
    if (_audioPlayer.state == PlayerState.completed ||
        _audioPlayer.state == PlayerState.stopped) {
      _start();
    } else if (_audioPlayer.state == PlayerState.playing) {
      _pause();
    } else if (_audioPlayer.state == PlayerState.paused) {
      _play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    super.build(context);
    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: width,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      // height: 1.8,
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              const SizedBox(width: 8),
              StreamBuilder<PlayerState>(
                  stream: _audioPlayer.onPlayerStateChanged,
                  builder: (context, snapshot) {
                    //print(snapshot.data);
                    return InkWell(
                      child: _checkIsPlaying
                          ? Icon(
                              Icons.pause_circle_filled,
                              color: _audioColor,
                              size: 36,
                            )
                          : Icon(
                              Icons.play_circle_filled,
                              color: _audioColor,
                              size: 36,
                            ),
                      onTap: () {
                        _playAndPause();
                      },
                    );
                  }),
              Expanded(
                child: StreamBuilder<Duration>(
                    stream: _audioPlayer.onPositionChanged,
                    builder: (context, snapshot) {
                      double sliderPosition = snapshot.data == null
                          ? 0.0
                          : snapshot.data!.inMilliseconds.toDouble();
                      String position =
                          DateTimeFormat.stringDuration(snapshot.data);
                      String duration =
                          DateTimeFormat.stringDuration(_duration);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            min: 0.0,
                            max: _duration.inMilliseconds.toDouble(),
                            value: sliderPosition,
                            activeColor: _audioColor,
                            inactiveColor: Colors.black,
                            onChanged: (v) {
                              _audioPlayer
                                  .seek(Duration(milliseconds: v.toInt()));
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 24.0, left: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  position,
                                  style: TextStyle(
                                    color: _audioColor,
                                  ),
                                ),
                                Text(
                                  duration,
                                  style: TextStyle(
                                    color: _audioColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
