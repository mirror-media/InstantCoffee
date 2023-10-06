import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

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
            CustomCachedNetworkImage(
              height: width / 16 * 9,
              width: width,
              imageUrl: record.photoUrl,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Text(
                record.title ?? StringDefault.valueNullDefault,
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
