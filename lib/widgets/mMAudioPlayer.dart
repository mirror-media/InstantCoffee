import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';

class MMAudioPlayer extends StatefulWidget {
  /// The baseUrl of the audio
  final String audioUrl;
  /// The title of audio
  final String title;
  /// The description of audio
  final String description;
  MMAudioPlayer({
    @required this.audioUrl,
    this.title,
    this.description,
  });

  @override
  _MMAudioPlayerState createState() => _MMAudioPlayerState();
}

class _MMAudioPlayerState extends State<MMAudioPlayer> {
  Color _audioColor = Colors.orange[800];
  AudioPlayer _audioPlayer;
  bool get _checkIsPlaying => !(_audioPlayer.state == null || 
    _audioPlayer.state == AudioPlayerState.COMPLETED || 
    _audioPlayer.state == AudioPlayerState.STOPPED ||
    _audioPlayer.state == AudioPlayerState.PAUSED);
  int _duration = 0;

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  void _initAudioPlayer() async{
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(widget.audioUrl);
    _duration = await _audioPlayer.getDuration();
    setState(() {
      
    });
  }

  _start() async {
    await _audioPlayer.play(widget.audioUrl);
  }

  _play() async {
    await _audioPlayer.resume();
  }

  _pause() async {
    await _audioPlayer.pause();
  }

  _playAndPause() {
    if(_audioPlayer.state == null || 
    _audioPlayer.state == AudioPlayerState.COMPLETED || 
    _audioPlayer.state == AudioPlayerState.STOPPED) {
      _start();
    }
    else if(_audioPlayer.state == AudioPlayerState.PLAYING) {
      _pause();
    }
    else if(_audioPlayer.state == AudioPlayerState.PAUSED) {
      _play();
    }
  }

  @override
  void dispose() {
    if(_audioPlayer.state != null) {
      _audioPlayer.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if(_duration == 0) {
      return Container();
    }

    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    // height: 1.8,
                  ),
                ),
              ),
            ),
          ),
          //SizedBox(height: 8,),
          Row(
            children: [
              SizedBox(width: 8),
              StreamBuilder<AudioPlayerState>(
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
                    onTap: (){_playAndPause();},
                  );
                }
              ),
              Expanded(
                child: StreamBuilder<Duration>(
                  stream: _audioPlayer.onAudioPositionChanged,
                  builder: (context, snapshot) {
                    double sliderPosition = snapshot.data == null
                      ? 0.0
                      : snapshot.data.inMilliseconds.toDouble();
                    String position = DateTimeFormat.stringDuration(snapshot.data);
                    String duration = DateTimeFormat.stringDuration(Duration(milliseconds: _duration));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          min: 0.0,
                          max: _duration.toDouble(),
                          value: sliderPosition,
                          activeColor: _audioColor,
                          inactiveColor: Colors.black,
                          onChanged: (v){
                            if(_audioPlayer.state != null) {
                              _audioPlayer.seek(Duration(milliseconds: v.toInt()));
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0, left: 24),
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
                  }
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}