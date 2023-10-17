import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class PremiumListItem extends StatelessWidget {
  final Record record;
  final GestureTapCallback? onTap;

  const PremiumListItem({
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageWidth = width / 2 - 4;
    double imageHeight = imageWidth / 1.6;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCachedNetworkImage(
            width: imageWidth,
            height: imageHeight,
            imageUrl: record.photoUrl,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              record.title ?? StringDefault.valueNullDefault,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
