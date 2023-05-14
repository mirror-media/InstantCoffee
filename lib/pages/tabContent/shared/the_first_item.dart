import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/models/record.dart';

class TheFirstItem extends StatelessWidget {
  final Record record;
  final GestureTapCallback? onTap;
  const TheFirstItem({
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CachedNetworkImage(
              height: width / 16 * 9,
              width: width,
              imageUrl: record.photoUrl,
              placeholder: (context, url) => Container(
                height: width / 16 * 9,
                width: width,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: width / 16 * 9,
                width: width,
                color: Colors.grey,
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Text(
                record.title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ],
        ));
  }
}
