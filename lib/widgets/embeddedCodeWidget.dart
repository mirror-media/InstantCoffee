import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:readr_app/widgets/fbEmbeddedCodeWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedCodeWidget extends StatefulWidget {
  final String embeddedCode;
  final double aspectRatio;
  EmbeddedCodeWidget({
    @required this.embeddedCode,
    this.aspectRatio,
  });

  @override
  _EmbeddedCodeWidgetState createState() => _EmbeddedCodeWidgetState();
}

class _EmbeddedCodeWidgetState extends State<EmbeddedCodeWidget> with AutomaticKeepAliveClientMixin {
  WebViewController _webViewController;
  bool _screenIsReseted;

  double _webViewWidth;
  double _webViewHeight;
  double _webViewAspectRatio;
  double _webViewBottomPadding;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _screenIsReseted = false;
    _webViewAspectRatio = widget.aspectRatio ?? 16 / 9;
    _webViewBottomPadding = 16;
    super.initState();
  }

  _loadHtmlFromAssets(String embeddedCode, double width) {
    String html = _getHtml(embeddedCode, width);

    if(embeddedCode.contains('class="tiktok-embed"')) {
      RegExp videoIdRegExp = new RegExp(
        r'data-video-id="(.[0-9]*)"',
        caseSensitive: false,
      );
      String videoId = videoIdRegExp.firstMatch(widget.embeddedCode).group(1);

      _webViewController.loadUrl(
        'https://www.tiktok.com/embed/v2/$videoId',
      );
    } else {
      _webViewController.loadUrl(
        Uri.dataFromString(
          html,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString()
      );
    }
  }

  String _getHtml(String embeddedCode, double width) {
    double scale = 1.0001;
    if(widget.embeddedCode.contains('www.facebook.com/plugins')) {
      RegExp widthRegExp = new RegExp(
        r'width="(.[0-9]*)"',
        caseSensitive: false,
      );
      double facebookIframeWidth = double.parse(widthRegExp.firstMatch(widget.embeddedCode).group(1));
      scale = width/facebookIframeWidth;
    }

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=$width, user-scalable=no, initial-scale=$scale, maximum-scale=$scale, minimum-scale=$scale, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="chrome=1">

  <title>Document</title>
  <style>
    body {
      margin: 0;
      padding: 0; 
      background: #F5F5F5;
    }
    div.iframe-width {
      width: 100%;
    }
  </style>
</head>
  <script src="https://www.instagram.com/embed.js"></script>
  <body>
    <center>
      <div class="iframe-width">
        $embeddedCode
      </div>
    </center>
  </body>
</html>
        ''';
  }

  // refer to the link(https://github.com/flutter/flutter/issues/2897)
  // webview will cause the device to crash in some physical android device, 
  // when the webview height is higher than the physical device screen height.
  // --------------------------------------------------
  // width : device screen width - 32(padding) 
  // height : device screen height
  // ratio : webview aspect ratio
  // width / ratio + bottomPadding : webview height + bottomPadding(padding)
  bool _isHigherThanScreenHeight(double width, double height, double ratio, double bottomPadding) {
    double webviewHeight = width / ratio;
    return (webviewHeight + bottomPadding) >  height;
  }

  double _getIframeHeight(double width, double height, double ratio, double bottomPadding) {
    if(Platform.isIOS) {
      return width / ratio + bottomPadding;
    }

    return _isHigherThanScreenHeight(width, height, ratio, bottomPadding) 
      ? height 
      : width / ratio + bottomPadding;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 32;
    var height = MediaQuery.of(context).size.height;

    super.build(context);
    // rendering a special iframe webview of facebook in android,
    // or it will be getting screen overflow.
    if(widget.embeddedCode.contains('www.facebook.com/plugins') && Platform.isAndroid){
      return FbEmbeddedCodeWidget(embeddedCode: widget.embeddedCode,);
    }

    return Container(
      width: width,
      height: _getIframeHeight(
        width, 
        height, 
        _webViewAspectRatio, 
        _webViewBottomPadding,
      ),
      child: Stack(
        children: [
          // display iframe
          Container(
            width: width,
            height: _getIframeHeight(
              width, 
              height, 
              _webViewAspectRatio, 
              _webViewBottomPadding,
            ),
            child: WebView(
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                _loadHtmlFromAssets(widget.embeddedCode, width);
              },
              javascriptMode: JavascriptMode.unrestricted,
              gestureRecognizers: null,
              onPageFinished: (e) async{
                if(widget.embeddedCode.contains('instagram-media')) {
                  await _webViewController.evaluateJavascript('instgrm.Embeds.process();');
                  // waiting for iframe rendering(workaround)
                  await Future.delayed(Duration(seconds: 5));
                  _webViewWidth = double.tryParse(
                    await _webViewController
                        .evaluateJavascript("document.documentElement.scrollWidth;"),
                  );
                  _webViewHeight = double.tryParse(
                    await _webViewController
                        .evaluateJavascript('document.querySelector(".instagram-media").getBoundingClientRect().height;'),
                  );
                } else if(widget.embeddedCode.contains('twitter-tweet')) {
                  // waiting for iframe rendering(workaround)
                  while (_webViewHeight == null || _webViewHeight == 0) {
                    await Future.delayed(Duration(seconds: 1));
                    _webViewHeight = double.tryParse(
                      await _webViewController
                          .evaluateJavascript('document.querySelector(".twitter-tweet").getBoundingClientRect().height;'),
                    );
                  }
                  _webViewWidth = double.tryParse(
                    await _webViewController
                        .evaluateJavascript('document.querySelector(".twitter-tweet").getBoundingClientRect().width;'),
                  );
                } else if(widget.embeddedCode.contains('www.facebook.com/plugins')) {
                  if(widget.embeddedCode.contains('www.facebook.com/plugins/video.php')) {
                    _webViewAspectRatio = 16/9;
                  }
                  _webViewBottomPadding = 0;
                } else {
                  if (_webViewController != null) {
                    _webViewWidth = double.tryParse(
                      await _webViewController
                          .evaluateJavascript("document.documentElement.scrollWidth;"),
                    );
                    _webViewHeight = double.tryParse(
                      await _webViewController
                          .evaluateJavascript("document.documentElement.scrollHeight;"),
                    );
                  }
                }
                // reset the webview size
                if(mounted && !_screenIsReseted) {
                  if(widget.embeddedCode.contains('www.facebook.com/plugins')) {
                    setState(() {
                      _screenIsReseted = true;
                    });
                  } else {
                    setState(() {
                      _screenIsReseted = true;
                      _webViewAspectRatio = _webViewWidth/_webViewHeight;
                    });
                  }
                }
              },
            ),
          ),
          // display watching more widget when meeting some conditions.
          if(_isHigherThanScreenHeight(
                width, height, 
                _webViewAspectRatio, _webViewBottomPadding
              ) && 
              Platform.isAndroid)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildWatchingMoreWidget(width),
            ),
          // cover a launching url widget over the iframe 
          // when the iframe is not google map.
          if(!widget.embeddedCode.contains('https://www.google.com/maps/embed'))
            InkWell(
              onTap: (){
                _launchUrl(widget.embeddedCode);
              },
              child: Container(
                width: width,
                height: _getIframeHeight(
                  width, 
                  height, 
                  _webViewAspectRatio, 
                  _webViewBottomPadding
                ),
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWatchingMoreWidget(double width) {
    return Container(
      height: width / 16 * 9 / 3,
      color: Colors.black.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Center(
          child: Text(
            '點擊觀看更多',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String embeddedCode) async{
    RegExp regExp;
    if(embeddedCode.contains('instagram-media')) {
      // permalink="(https:\/\/www\.instagram\.com\/p\/\w+\/)
      regExp = new RegExp(
        r'permalink="(https:\/\/www\.instagram\.com\/p\/\w+\/)',
        caseSensitive: false,
      );
    } else if(embeddedCode.contains('twitter-tweet')){
      // (?>(https:\/\/twitter\.com\/\w{1,15}\/status\/\d+))
      regExp = new RegExp(
        r'(https?:\/\/twitter\.com\/\w{1,15}\/status\/\d+)',
        caseSensitive: false,
      );
    } else if(embeddedCode.contains('www.facebook.com/plugins')) {
      // refer to https://www.facebook.com/help/105399436216001
      regExp = new RegExp(
        r'https:\/\/www\.facebook\.com\/plugins\/(?:post|video)\.php\?href=(https?(%3A|\:)(%2F|\\)(%2F|\\)www\.facebook\.com(%2F|\\)(?:[a-zA-Z0-9.]+)(%2F|\\)(?:posts|videos)(%2F|\\)[0-9]+)(%2F?|\\?)\&',
        caseSensitive: false,
      );
    } else if(embeddedCode.contains('https://embed.dcard.tw/v1/posts')) {
      regExp = new RegExp(
        r'(https:\/\/embed.dcard.tw\/v1\/posts\/[0-9]+)',
        caseSensitive: false,
      );
    } else if(embeddedCode.contains('class="tiktok-embed"')) {
      regExp = new RegExp(
        r'cite="(https:\/\/www.tiktok.com\/.*)" data-video-id="',
        caseSensitive: false,
      );
    } 

    if(regExp != null) {
      var url = regExp.firstMatch(embeddedCode).group(1);
      url = Uri.decodeFull(url);
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
