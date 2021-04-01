import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/magazineList.dart';

class MagazineListWidget extends StatefulWidget {
  final MagazineList magazineList;
  MagazineListWidget({
    @required this.magazineList,
  });

  @override
  _MagazineListWidgetState createState() => _MagazineListWidgetState();
}

class _MagazineListWidgetState extends State<MagazineListWidget> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.magazineList.length,
      itemBuilder: (context, index) {
        if(index == 0) {
          return Column(
            children: [
              if(!_hasError)
                Container(height: 48, width: width,),
              if(_hasError)
                Container(
                  height: 48,
                  width: width,
                  color: Color(0xFFFFF8F9),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '下載失敗，請再試一次',
                        style: TextStyle(
                          color: Color(0xFFDB1730),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0, right: 24
                ),
                child: _buildTheFirstMagazine(
                  context,
                  width, 
                  24, 
                  widget.magazineList[index]
                ),
              ),
              SizedBox(height: 32),
            ],
          );
        }
        
        return Column(
          children: [
            if(index == 1)
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
            _buildMagazine(
              context,
              width, 
              24, 
              widget.magazineList[index],
            ),
            if(index != widget.magazineList.length-1)
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0
                ),
                child: Divider(),
              ),
            if(index == widget.magazineList.length-1)
              Container(
                width: width,
                color: Color(0xffE5E5E5),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0, bottom: 12.0,
                  ),
                  child: Center(
                    child: Text(
                      '所有期數都在上面囉',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
          ],
        );
      }
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

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0, bottom: 20.0,
          left: 24.0, right: 24.0
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
            Container(
              height: imageHeight,
              child: Center(
                child: Icon(
                  Icons.download_sharp,
                  size: 36,
                  color: appColor,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _navigateToMagazineBrowser(magazine);
      },
    );
  }

  void _navigateToMagazineBrowser(Magazine magazine) async{
    if(magazine.pdfUrl == null || magazine.pdfUrl == '') {
      setState(() {
        _hasError = true;
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _hasError = false;
      });
    } else {
      RouteGenerator.navigateToMagazineBrowser(context, magazine);
    }
  }
}