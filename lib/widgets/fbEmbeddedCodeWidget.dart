import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FbEmbeddedCodeWidget extends StatefulWidget {
  final String embeddedCoede;
  FbEmbeddedCodeWidget({
    @required this.embeddedCoede,
  });

  @override
  _FbEmbeddedCodeWidgetState createState() => _FbEmbeddedCodeWidgetState();
}

class _FbEmbeddedCodeWidgetState extends State<FbEmbeddedCodeWidget> {
  String _htmlPage = '';
  double _ratio = 16/9;
  bool _isVideo = false;

  @override
  void initState() {
    RegExp regExp = new RegExp(
      r'src="https:\/\/www\.facebook\.com\/plugins\/(post|video)\.php\?href=(https?(%3A|\:)(%2F|\\)(%2F|\\)www\.facebook\.com(%2F|\\)\w+(%2F|\\)(?:posts|videos)(%2F|\\)[0-9]+)(%2F?|\\?)\&',
      caseSensitive: false,
    );

    if(regExp.hasMatch(widget.embeddedCoede)) {
      _isVideo = regExp.firstMatch(widget.embeddedCoede).group(1) == 'video';
      String fbUrl = regExp.firstMatch(widget.embeddedCoede).group(2);
      _htmlPage = 'https://www.facebook.com/plugins/post.php?href='+fbUrl;
      print(_htmlPage);
      RegExp widthRegExp = new RegExp(
        r'width="(.[0-9]*)"',
        caseSensitive: false,
      );
      RegExp heightRegExp = new RegExp(
        r'height="(.[0-9]*)"',
        caseSensitive: false,
      );
      double w = double.parse(widthRegExp.firstMatch(widget.embeddedCoede).group(1));
      double h = double.parse(heightRegExp.firstMatch(widget.embeddedCoede).group(1));
      _ratio = w/h;
    }
    super.initState();
  }

  double _getIframeHeight(double width, double ratio) {
    return (_isVideo || Platform.isIOS) ? width/16*9+8 : width/ratio/0.8;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width-32;
    RegExp widthRegExp = new RegExp(
      r'width=(.[0-9]*)',
      caseSensitive: false,
    );
    RegExp heightRegExp = new RegExp(
      r'height=(.[0-9]*)',
      caseSensitive: false,
    );
    if(widthRegExp.hasMatch(_htmlPage)) {
      _htmlPage = _htmlPage.replaceFirst(widthRegExp, 'width=500');
    }
    else {
      _htmlPage = _htmlPage+'&width=500';
    }
    if(heightRegExp.hasMatch(_htmlPage)) {
      _htmlPage = _htmlPage.replaceFirst(heightRegExp, '');
    }

    return Stack(
      children: [
        Container(
          width: width,
          height: _getIframeHeight(width, _ratio),
          child: WebView(
            initialUrl: _htmlPage,
            //userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
        InkWell(
          onTap: ()async{
            RegExp regExp = new RegExp(
              r'https:\/\/www\.facebook\.com\/plugins\/(?:post|video)\.php\?href=(https?(%3A|\:)(%2F|\\)(%2F|\\)www\.facebook\.com(%2F|\\)\w+(%2F|\\)(?:posts|videos)(%2F|\\)[0-9]+)(%2F?|\\?)\&',
              caseSensitive: false,
            );

            if(regExp != null) {
              var url = regExp.firstMatch(widget.embeddedCoede).group(1);
              url = Uri.decodeFull(url);
              print(url);
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          },
          child: Container(
            width: width,
            height: _getIframeHeight(width, _ratio),
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}