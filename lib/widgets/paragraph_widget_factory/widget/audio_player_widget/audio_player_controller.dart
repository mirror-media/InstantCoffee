import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  AudioPlayer? audioPlayer;
  String? audioSourceUrl;

  final RxDouble rxSlideValue = 0.0.obs;
  final Rx<PlayerState> rxCurrentAudioState =
      Rx<PlayerState>(PlayerState.stopped);
  final Rxn<Duration> rxCurrentDuration = Rxn();
  final Rxn<Duration> rxAudioDuration = Rxn();

  AudioPlayerController(String? audioUrl) {
    audioSourceUrl = audioUrl;
  }

  @override
  void onInit() async {
    super.onInit();
    audioPlayer = AudioPlayer();
    audioPlayer?.setSourceUrl(audioSourceUrl!);
    rxAudioDuration.value =await audioPlayer?.getDuration();
    rxCurrentDuration.value =const Duration();
    audioPlayer?.onPlayerStateChanged.listen(audioPlayerStateChangeEvent);
    audioPlayer?.onPositionChanged.listen(audioPositionChangeEvent);
  }

  void playAudio() async {
    if (audioSourceUrl != null) {
      audioPlayer?.play(UrlSource(audioSourceUrl!));
      rxAudioDuration.value = await audioPlayer?.getDuration();
    }
  }

  void audioPlayerStateChangeEvent(PlayerState state) {
    rxCurrentAudioState.value = state;
  }

  void audioPositionChangeEvent(Duration duration) {
    rxCurrentDuration.value = duration;
    rxSlideValue.value= duration.inMilliseconds.toDouble();
  }

  void sliderChangeEvent(double value) {
    rxSlideValue.value =value;
    audioPlayer?.pause();
    audioPlayer?.seek(Duration(milliseconds: value.toInt()));
  }

  void playPauseButtonClick() async {
    switch (rxCurrentAudioState.value) {
      case PlayerState.playing:
        audioPlayer?.pause();
        break;
      case PlayerState.paused:
        playAudio();
        break;
      case PlayerState.stopped:
      case PlayerState.completed:
        playAudio();
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer?.stop();
  }
}
