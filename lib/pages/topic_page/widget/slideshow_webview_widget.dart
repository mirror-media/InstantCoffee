import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SlideshowWebViewWidget extends StatefulWidget {
  final String topicId;

  const SlideshowWebViewWidget(this.topicId, {Key? key}) : super(key: key);

  @override
  State<SlideshowWebViewWidget> createState() => _SlideshowWebViewWidgetState();
}

class _SlideshowWebViewWidgetState extends State<SlideshowWebViewWidget> {
  bool _isLoading = true;
  late String url;
  double _aspectRatio = 16 / 9;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    url = '${Environment().config.mirrorMediaDomain}/topic/${widget.topicId}';
    print(url);
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
                        "document.getElementsByClassName('gdpr__Wrapper-sc-f0ad663b-0 dZwCMJ')[0].style.display = 'none';");
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
                            "document.getElementsByClassName('topic-list__Topic-sc-820f3557-1 kIKGxx topic')[0].offsetWidth");
                    final String height =
                        await _webViewController.runJavascriptReturningResult(
                            "document.getElementsByClassName('topic-list__Topic-sc-820f3557-1 kIKGxx topic')[0].offsetHeight");
                    setState(() {
                      _aspectRatio = int.parse(width) / int.parse(height);
                      _isLoading = false;
                    });
                  },
                  navigationDelegate: (navigation) async {
                    if (!_isLoading) {
                      final url = navigation.url;
                      if (url
                          .contains(Environment().config.mirrorMediaDomain)) {
                        if (!context.read<MemberBloc>().state.isPremium) {
                          AdHelper adHelper = AdHelper();
                          adHelper.checkToShowInterstitialAd();
                        }
                        /// PM:先註解掉 後續再確認是否真的有這個情境
                        final startIndex = url.indexOf('story/');
                        // String storySlug = url.replaceRange(0, startIndex, '');
                        // storySlug = storySlug.replaceAll('story/', '');
                        // storySlug = storySlug.replaceAll('/', '');
                        // RouteGenerator.navigateToStory(storySlug);
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
