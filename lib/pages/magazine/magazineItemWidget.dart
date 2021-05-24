import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineItemWidget extends StatelessWidget {
  final Magazine magazine;
  final double padding;
  MagazineItemWidget({
    @required this.magazine,
    this.padding = 24.0
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageWidth = (width-padding*2)/4.5;
    double imageHeight = imageWidth/0.75;

    DateTimeFormat dateTimeFormat = DateTimeFormat();
    String publishedDate = dateTimeFormat.changeDatabaseStringToDisplayString(
      magazine.publishedDate, 
      'yyyy/MM/dd'
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0, bottom: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _displayMagazineImage(imageWidth, imageHeight, magazine),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  magazine.issue,
                  style: TextStyle(
                    fontSize: 13,
                    color: appColor,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(width: 8),
                Text(
                  publishedDate,
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 8.0),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    text: magazine.title,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: InkWell(
              child: Container(
                height: imageHeight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Ink(
                      width: 31,
                      height: 33,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(magazineDownloadIconPng),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                _navigateToMagazineBrowser(context, magazine);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayMagazineImage(double imageWidth, double imageHeight, Magazine magazine) {
    return CachedNetworkImage(
      height: imageHeight,
      width: imageWidth,
      imageUrl: magazine.photoUrl,
      placeholder: (context, url) => Container(
        height: imageHeight,
        width: imageWidth,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: imageHeight,
        width: imageWidth,
        color: Colors.grey,
        child: Icon(Icons.error),
      ),
      fit: BoxFit.cover,
    );
  }

  void _navigateToMagazineBrowser(
    BuildContext context,
    Magazine magazine) async{
    if(magazine.pdfUrl == null || magazine.pdfUrl == '') {
      Fluttertoast.showToast(
        msg: '下載失敗，請再試一次',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      RouteGenerator.navigateToMagazineBrowser(context, magazine);
    }
  }
}