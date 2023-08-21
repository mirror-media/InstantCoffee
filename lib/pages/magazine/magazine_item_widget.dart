import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineItemWidget extends StatelessWidget {
  final Magazine magazine;
  final double padding;

  const MagazineItemWidget({required this.magazine, this.padding = 24.0});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageWidth = (width - padding * 2) / 4.5;
    double imageHeight = imageWidth / 0.75;
    String publishedDate = magazine.publishedDate?.formattedDateTime() ??
        StringDefault.valueNullDefault;

    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //height: imageHeight + 10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayMagazineImage(imageWidth, imageHeight, magazine),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48 - imageWidth - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    magazine.issue ?? StringDefault.valueNullDefault,
                    style: const TextStyle(
                      fontSize: 13,
                      color: appColor,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    publishedDate,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AutoSizeText(
                    magazine.title ?? StringDefault.valueNullDefault,
                    maxLines: 2,
                    minFontSize: 15,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.only(top: 12, bottom: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        TextButton.icon(
            icon: SvgPicture.asset(
              bookIconSvg,
              color: appColor,
              width: 16,
              height: 14,
            ),
            label: const Text(
              '線上閱讀',
              style: TextStyle(
                fontSize: 15,
                color: appColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () =>
                RouteGenerator.navigateToMagazineBrowser(magazine)),
      ]),
    );
  }

  Widget _displayMagazineImage(
      double imageWidth, double imageHeight, Magazine magazine) {
    return CachedNetworkImage(
      height: imageHeight,
      width: imageWidth,
      imageUrl: magazine.photoUrl ?? StringDefault.valueNullDefault,
      placeholder: (context, url) => Container(
        height: imageHeight,
        width: imageWidth,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: imageHeight,
        width: imageWidth,
        color: Colors.grey,
        child: const Icon(Icons.error),
      ),
      fit: BoxFit.cover,
    );
  }
}
