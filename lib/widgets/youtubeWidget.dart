import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWidget extends StatelessWidget {
  final String youtubeId;
  final String description;
  YoutubeWidget({
    @required this.youtubeId,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 32;

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
        if (description != '')
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
