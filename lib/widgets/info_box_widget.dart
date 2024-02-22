import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/widgets/triangle_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBoxWidget extends StatelessWidget with Logger {
  final String title;
  final String description;
  final bool isMemberContent;

  const InfoBoxWidget({
    required this.title,
    required this.description,
    this.isMemberContent = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isMemberContent) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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
                  textStyle: const TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: Color.fromRGBO(0, 0, 0, 0.66),
                  ),
                  customStylesBuilder: (element) {
                    if (element.localName == 'a') {
                      return {'color': 'blue'};
                    }

                    return null;
                  },
                  onTapUrl: (url) async {
                    try {
                      String newUrl = url.replaceAll(' ', '');
                      Uri uri = Uri.parse(newUrl);
                      return await launchUrl(uri);
                    } catch (e) {
                      debugLog(e);
                      return false;
                    }
                  },
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: appColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HtmlWidget(
                    description,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      //color: color,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'a') {
                        return {'color': 'blue'};
                      }

                      return null;
                    },
                    onTapUrl: (url) async {
                      try {
                        String newUrl = url.replaceAll(' ', '');
                        Uri uri = Uri.parse(newUrl);
                        return await launchUrl(uri);
                      } catch (e) {
                        debugLog(e);
                        return false;
                      }
                    },
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
                strokeColor: Colors.grey.shade600,
                strokeWidth: 10,
                paintingStyle: PaintingStyle.fill,
              ),
              child: const SizedBox(
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
