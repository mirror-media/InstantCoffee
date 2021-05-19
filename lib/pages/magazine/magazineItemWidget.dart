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
                _displayIssueAndPublishedDate(magazine),
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
          InkWell(
            child: Container(
              height: imageHeight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    Icons.download_sharp,
                    size: 36,
                    color: appColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              _navigateToMagazineBrowser(context, magazine);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _displayIssueAndPublishedDate(Magazine magazine) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();
    String publishedDate = dateTimeFormat.changeDatabaseStringToDisplayString(
      magazine.publishedDate, 
      'yyyy/MM/dd'
    );

    return Row(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            magazine.issue,
            style: TextStyle(
              fontSize: 13,
              color: appColor,
            ),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(width: 8),
        Text(
          publishedDate,
          style: TextStyle(fontSize: 13),
        ),
      ]
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