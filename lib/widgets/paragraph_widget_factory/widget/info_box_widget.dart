import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../triangle_painter.dart';

class InfoBoxWidget extends StatelessWidget {
  final Paragraph paragraph;

  const InfoBoxWidget({Key? key, required this.paragraph}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: const Border(
                top: BorderSide(
                  width: 1.5,
                  color: appColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    HtmlWidget(
                      paragraph.contents![0].data ??StringDefault.valueNullDefault,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(5, 79, 119, 1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    HtmlWidget(
                      paragraph.contents![0].description??StringDefault.valueNullDefault,
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
                          // debugLog(e);
                          return false;
                        }
                      },
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
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
