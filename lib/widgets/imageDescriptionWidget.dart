import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class ImageDescriptionWidget extends StatelessWidget {
  final String imageUrl;
  final String description;
  final double width;
  final double aspectRatio;
  final double textSize;
  final bool isMemberContent;
  final List<String> imageUrlList;
  ImageDescriptionWidget({
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

    if(isMemberContent){
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32),
        shrinkWrap: true,
        children: [
          if (imageUrl != '')
            InkWell(
              onTap: () {
                int index = imageUrlList.indexOf(imageUrl);
                if(index == -1){
                  index = 0;
                }
                RouteGenerator.navigateToImageViewer(imageUrlList, openIndex: index);
              },
              child: CachedNetworkImage(
                width: width,
                imageUrl: imageUrl,
                placeholder: (context, url) => Container(
                  height: height,
                  width: width,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Container(
                  height: height,
                  width: width,
                  color: Colors.grey,
                  child: Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
          if (description != '')...[
            const SizedBox(
              height: 12,
            ),
            Divider(
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
            CachedNetworkImage(
              //height: imageHeight,
              width: width,
              imageUrl: imageUrl,
              placeholder: (context, url) => Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: height,
                width: width,
                color: Colors.grey,
                child: Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
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
        if(index == -1){
          index = 0;
        }
        RouteGenerator.navigateToImageViewer(imageUrlList, openIndex: index);
      },
    );
  }
}
