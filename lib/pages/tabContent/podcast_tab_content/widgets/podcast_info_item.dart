import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/podcast_info/podcast_info.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class PodcastInfoItem extends StatelessWidget {
  const PodcastInfoItem(
      {Key? key,
      required this.podcastInfo,
      required this.descriptionClick,
      required this.isPlaying,
      required this.playClick})
      : super(key: key);
  final PodcastInfo podcastInfo;
  final bool isPlaying;
  final Function(String?) descriptionClick;
  final Function() playClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            height: 26,
            color: Colors.black87,
            alignment: Alignment.centerLeft),
        InkWell(
          onTap: playClick,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomCachedNetworkImage(
                  imageUrl: podcastInfo.heroImage ?? '',
                  width: double.infinity),
              Center(
                  child: Image.asset(
                isPlaying
                    ? 'assets/image/stop_icon.png'
                    : 'assets/image/play_icon.png',
                width: 52,
                height: 52,
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Text(
                podcastInfo.title ?? StringDefault.valueNullDefault,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'PingFang TC',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    podcastInfo.duration ?? StringDefault.valueNullDefault,
                    style: const TextStyle(
                        color: Color(0xFFFFA011),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'Noto Sans TC'),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: ()=> descriptionClick(podcastInfo.description),
                    child: Container(
                        width: 48,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Text(
                          '節目介紹',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),),
                  )
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 87,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                '主持人',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: 'PingFang TC'),
              ),
              Text(
                podcastInfo.author ?? StringDefault.valueNullDefault,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'PingFang TC'),
              ),
              const SizedBox(height: 8),
              Text(
                podcastInfo.timeFormat ?? StringDefault.valueNullDefault,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'PingFang TC'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
