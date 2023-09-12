import 'package:flutter/material.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class ListItem extends StatelessWidget {
  final Record record;
  final GestureTapCallback? onTap;

  const ListItem({
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageSize = 25 * (width - 32) / 100;

    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      record.title,
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
        ));
  }
}
