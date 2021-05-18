import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/magazineList.dart';

class WeeklyMagazineListWidget extends StatefulWidget {
  final MagazineList magazineList;
  WeeklyMagazineListWidget({
    @required this.magazineList,
  });

  @override
  _WeeklyMagazineListWidgetState createState() => _WeeklyMagazineListWidgetState();
}

class _WeeklyMagazineListWidgetState extends State<WeeklyMagazineListWidget> {
 List<Magazine> _currentMagazineList;
 List<Magazine> _remainMagazineList;

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
      return List<Magazine>();
    }
    return magazineList.sublist(2, magazineList.length);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if(_currentMagazineList.length > 0)
          Container(
            width: width,
            color: Color(0xffE5E5E5),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 36.0, bottom: 12.0,
                left: 24.0, right: 24.0
              ),
              child: Text(
                '當期雜誌',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(
              left: 24.0, right: 24,
            ),
            child: Divider(),
          ),
          itemCount: _currentMagazineList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 24.0, right: 24,
                top: 16, bottom: 16
              ),
              child: _buildTheFirstMagazine(
                context,
                width, 
                24, 
                widget.magazineList[index]
              ),
            );
          }
        ),
        SizedBox(height: 16),
        if(_remainMagazineList.length > 0)
          Container(
            width: width,
            color: Color(0xffE5E5E5),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 36.0, bottom: 12.0,
                left: 24.0, right: 24.0
              ),
              child: Text(
                '所有期數',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(
              left: 24.0, right: 24,
            ),
            child: Divider(),
          ),
          itemCount: _remainMagazineList.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(
                left: 24.0, right: 24,
              ),
              child: _buildMagazine(
                context,
                width, 
                24, 
                widget.magazineList[index],
              ),
            );
          }
        ),
      ],
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

  Widget _buildTheFirstMagazine(
    BuildContext context,
    double width, 
    double padding, 
    Magazine magazine
  ) {
    double imageWidth = (width-padding*2)/2.5;
    double imageHeight = imageWidth/0.75;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayMagazineImage(imageWidth, imageHeight, magazine),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            height: imageHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                RaisedButton(
                  color: appColor,
                  child: Container(
                    width: width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '下載當期雜誌',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onPressed: (){
                    _navigateToMagazineBrowser(magazine);
                  }
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget _buildMagazine(
    BuildContext context,
    double width, 
    double padding, 
    Magazine magazine,
  ) {
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
              _navigateToMagazineBrowser(magazine);
            },
          ),
        ],
      ),
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
      RouteGenerator.navigateToMagazineBrowser(context, magazine);
    }
  }
}