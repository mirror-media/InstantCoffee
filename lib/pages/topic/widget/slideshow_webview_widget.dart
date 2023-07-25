import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SlideshowWebviewWidget extends StatefulWidget {
  final String topicId;
  const SlideshowWebviewWidget(this.topicId, {Key? key}) : super(key: key);

  @override
  State<SlideshowWebviewWidget> createState() => _SlideshowWebviewWidgetState();
}

class _SlideshowWebviewWidgetState extends State<SlideshowWebviewWidget> {
  bool _isLoading = true;
  late String url;
  double _aspectRatio = 16 / 9;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    url = '${Environment().config.mirrorMediaDomain}/topic/${widget.topicId}';
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE2E5E7),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth / _aspectRatio,
              child: WebView(
                  onWebViewCreated: (WebViewController webViewController) {
                    _webViewController = webViewController;
                    _webViewController.loadUrl(url);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureRecognizers: null,
                  onPageFinished: (e) async {
                    _webViewController.runJavascript(
                        "document.getElementsByTagName('header')[0].style.display = 'none';");
                    _webViewController.runJavascript(
                        "document.getElementsByTagName('footer')[0].style.display = 'none';");
                    _webViewController.runJavascript(
                        "document.getElementsByClassName('article-list')[0].style.display = 'none';");
                    _webViewController.runJavascript(
                        "document.getElementsByClassName('the-gdpr')[0].style.display = 'none';");
                    final String width =
                        await _webViewController.runJavascriptReturningResult(
                            "document.getElementsByClassName('topic-wrapper')[0].offsetWidth");
                    final String height =
                        await _webViewController.runJavascriptReturningResult(
                            "document.getElementsByClassName('topic-wrapper')[0].offsetHeight");
                    setState(() {
                      _aspectRatio = int.parse(width) / int.parse(height);
                      _isLoading = false;
                    });
                  },
                  navigationDelegate: (navigation) async {
                    if (!_isLoading) {
                      final url = navigation.url;
                      if (url.contains('story') &&
                          url.contains(
                              Environment().config.mirrorMediaDomain)) {
                        if (!context.read<MemberBloc>().state.isPremium) {
                          AdHelper adHelper = AdHelper();
                          adHelper.checkToShowInterstitialAd();
                        }
                        final startIndex = url.indexOf('story/');
                        String storySlug = url.replaceRange(0, startIndex, '');
                        storySlug = storySlug.replaceAll('story/', '');
                        storySlug = storySlug.replaceAll('/', '');
                        RouteGenerator.navigateToStory(storySlug);
                      } else {
                        launchUrlString(url);
                      }
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  }),
            );
          }),
        ),
        if (_isLoading)
          Container(
            width: Get.width,
            height: Get.width / _aspectRatio,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator.adaptive()),
          )
      ],
    );
  }
}
