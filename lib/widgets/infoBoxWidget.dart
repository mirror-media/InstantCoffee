import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/widgets/trianglePainter.dart';

class InfoBoxWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool isMemberContent;
  InfoBoxWidget({
    @required this.title,
    @required this.description,
    this.isMemberContent = false,
  });
  @override
  Widget build(BuildContext context) {
    if(isMemberContent){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape: Border(
            top: BorderSide(
              width: 1.5,
              color: appColor, 
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(5, 79, 119, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                HtmlWidget(
                  description,
                  hyperlinkColor: Colors.blue[900],
                  textStyle: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: Color.fromRGBO(0, 0, 0, 0.66),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      color: appColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HtmlWidget(
                    description,
                    hyperlinkColor: Colors.blue[900],
                    textStyle: TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      //color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 24,
              width: 42,
              color: appColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 44.0),
            child: CustomPaint(
              painter: TrianglePainter(
                strokeColor: Colors.grey[600],
                strokeWidth: 10,
                paintingStyle: PaintingStyle.fill,
              ),
              child: Container(
                height: 12,
                width: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
