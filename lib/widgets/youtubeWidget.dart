import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWidget extends StatelessWidget {
  final String youtubeId;
  final String description;
  final double width;
  YoutubeWidget({
    @required this.width,
    @required this.youtubeId,
    this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: width / 16 * 9,
          child: WebView(
            initialUrl: 'https://www.youtube.com/embed/$youtubeId',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
        if (description!=null && description != '')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
