import 'package:flutter/material.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class ImageDescriptionWidget extends StatelessWidget {
  final String imageUrl;
  final String description;
  final double width;
  final double aspectRatio;
  final double textSize;
  final bool isMemberContent;
  final List<String> imageUrlList;

  const ImageDescriptionWidget({
    required this.imageUrl,
    required this.description,
    required this.width,
    required this.imageUrlList,
    this.aspectRatio = 16 / 9,
    this.textSize = 16,
    this.isMemberContent = false,
  });

  @override
  Widget build(BuildContext context) {
    double height = width / aspectRatio;

    if (isMemberContent) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32),
        shrinkWrap: true,
        children: [
          if (imageUrl != '')
            InkWell(
              onTap: () {
                int index = imageUrlList.indexOf(imageUrl);
                if (index == -1) {
                  index = 0;
                }
                RouteGenerator.navigateToImageViewer(imageUrlList,
                    openIndex: index);
              },
              child: CustomCachedNetworkImage(
                width: width,
                height: height,
                imageUrl: imageUrl,
              ),
            ),
          if (description != '') ...[
            const SizedBox(
              height: 12,
            ),
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              thickness: 1,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 20, left: 20),
              child: Text(
                description,
                style: TextStyle(fontSize: textSize, color: Colors.black54),
              ),
            ),
          ],
        ],
      );
    }

    return InkWell(
      child: Wrap(
        //direction: Axis.vertical,
        children: [
          if (imageUrl != '')
            CustomCachedNetworkImage(
                imageUrl: imageUrl, width: width, height: height),
          if (description != '')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: textSize, color: Colors.grey),
              ),
            ),
        ],
      ),
      onTap: () {
        int index = imageUrlList.indexOf(imageUrl);
        if (index == -1) {
          index = 0;
        }
        RouteGenerator.navigateToImageViewer(imageUrlList, openIndex: index);
      },
    );
  }
}
