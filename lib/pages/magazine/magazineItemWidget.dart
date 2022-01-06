import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        top: 16.0, bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //height: imageHeight + 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _displayMagazineImage(imageWidth, imageHeight, magazine),
                Container(
                  width: MediaQuery.of(context).size.width - 48 - imageWidth - 20,
                  child: Column(
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
                      SizedBox(height: 2.0),
                      Text(
                        publishedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      AutoSizeText(
                        magazine.title,
                        maxLines: 2,
                        minFontSize: 15,
                        style: TextStyle(
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
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
            label: Text(
              '線上閱讀',
              style: TextStyle(
              fontSize: 15,
              color: appColor,
              fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: (){
              _navigateToMagazineBrowser(context,magazine);
            }
          ),
        ]
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
      RouteGenerator.navigateToMagazineBrowser(magazine);
    }
  }
}