import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/pages/magazine/magazineItemWidget.dart';
import 'package:readr_app/pages/magazine/magazineListLabel.dart';

class WeeklyMagazineListWidget extends StatefulWidget {
  final MagazineList magazineList;
  WeeklyMagazineListWidget({
    required this.magazineList,
  });

  @override
  _WeeklyMagazineListWidgetState createState() => _WeeklyMagazineListWidgetState();
}

class _WeeklyMagazineListWidgetState extends State<WeeklyMagazineListWidget> {
 late List<Magazine> _currentMagazineList;
 late List<Magazine> _remainMagazineList;

  @override
  void initState() {
    _currentMagazineList = getCurrentMagazineList(widget.magazineList);
    _remainMagazineList = getRemainMagazineList(widget.magazineList);
    super.initState();
  }

  List<Magazine> getCurrentMagazineList(MagazineList magazineList) {
    if(magazineList.length < 2) {
      return magazineList;
    }
    return magazineList.sublist(0, 2);
  }

  List<Magazine> getRemainMagazineList(MagazineList magazineList) {
    if(magazineList.length < 3) {
      return [];
    }
    return magazineList.sublist(2, magazineList.length);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if(_currentMagazineList.length > 0)
          MagazineListLabel(label: '當期雜誌'),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Container(
            height: 4,
            color: Color.fromRGBO(248, 248, 249, 1),
          ),
          itemCount: _currentMagazineList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 24.0, right: 24,
                top: 20, bottom: 16
              ),
              child: _buildTheFirstMagazine(
                context,
                width, 
                24, 
                _currentMagazineList[index]
              ),
            );
          }
        ),
        if(_remainMagazineList.length > 0)
          MagazineListLabel(label: '近期雜誌',),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Container(
            height: 4,
            color: Color.fromRGBO(248, 248, 249, 1),
          ),
          itemCount: _remainMagazineList.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(
                left: 24.0, right: 24,
              ),
              child: MagazineItemWidget(
                magazine: _remainMagazineList[index],
              ),
            );
          }
        ),
      ],
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

  Widget _buildTheFirstMagazine(
    BuildContext context,
    double width, 
    double padding, 
    Magazine magazine
  ) {
    double imageWidth = (width-padding*2)/2.5;
    double imageHeight = imageWidth/0.75;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: imageHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayMagazineImage(imageWidth, imageHeight, magazine),
              Container(
                width: MediaQuery.of(context).size.width - 48 - imageWidth - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      magazine.issue,
                      style: TextStyle(
                        fontSize: 15,
                        color: appColor,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
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
            _navigateToMagazineBrowser(magazine);
          }
        ),
      ]
    );
  }

  void _navigateToMagazineBrowser(Magazine magazine) async{
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