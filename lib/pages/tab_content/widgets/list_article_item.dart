import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class ListArticleItem extends StatelessWidget {
  final Record record;
  final GestureTapCallback? onTap;

  const ListArticleItem({
    Key? key,
    required this.record,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double imageSize = 25 * (width - 32) / 100;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.title ?? StringDefault.valueNullDefault,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              CustomCachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: record.photoUrl),
            ],
          ),
        ],
      ),
    );
  }
}
