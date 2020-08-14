import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedCodeWidget extends StatefulWidget {
  final String embeddedCoede;
  EmbeddedCodeWidget({
    @required this.embeddedCoede,
  });

  @override
  _EmbeddedCodeWidgetState createState() => _EmbeddedCodeWidgetState();
}

class _EmbeddedCodeWidgetState extends State<EmbeddedCodeWidget> {
  String htmlPage = '';
  double ratio = 16 / 9;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 32;
    htmlPage = '''
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        background: #F5F5F5;
      }
      .w-480 {
        margin: 0 auto;
        max-width: 504px;
      }
    </style>
  </head>
  <body>
    <div class="row w-480">
      ${widget.embeddedCoede}
	  </div>
  </body>
</html>
    ''';

    return Container(
      width: width,
      height: (isVideo || Platform.isIOS)
          ? width / 16 * 9 + 8
          : width / ratio / 0.8,
      child: WebView(
        initialUrl:
            Uri.dataFromString(htmlPage, mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
