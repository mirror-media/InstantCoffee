

import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidgetController extends GetxController{
  late VideoPlayerController videoPlayerController;
  late ChewieController? chewieController;
  final RxBool rxIsInitialization = false.obs;
  String? videoUrl;
  VideoPlayerWidgetController(this.videoUrl);

  Future<void> configVideoPlayer() async {
    if(videoUrl==null)return ;
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl!));
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16/9,
      autoInitialize: true,
      customControls: const MaterialControls(),
    );
    rxIsInitialization.value=true;
  }

  @override
  void onInit() {
    super.onInit();
    configVideoPlayer();
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}