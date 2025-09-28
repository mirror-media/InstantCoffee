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

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) async {
          await _webViewController.runJavaScript(
              "document.getElementsByClassName('gdpr__Wrapper-sc-f0ad663b-0 dZwCMJ')[0].style.display = 'none';");
          await _webViewController.runJavaScript(
              "document.getElementsByTagName('header')[0].style.display = 'none';");
          await _webViewController.runJavaScript(
              "document.getElementsByTagName('footer')[0].style.display = 'none';");
          await _webViewController.runJavaScript(
              "document.getElementsByClassName('article-list')[0].style.display = 'none';");
          await _webViewController.runJavaScript(
              "document.getElementsByClassName('the-gdpr')[0].style.display = 'none';");

          final String width =
              await _webViewController.runJavaScriptReturningResult(
                      "document.getElementsByClassName('topic-list__Topic-sc-820f3557-1 kIKGxx topic')[0].offsetWidth")
                  as String;
          final String height =
              await _webViewController.runJavaScriptReturningResult(
                      "document.getElementsByClassName('topic-list__Topic-sc-820f3557-1 kIKGxx topic')[0].offsetHeight")
                  as String;

          setState(() {
            _aspectRatio = int.parse(width) / int.parse(height);
            _isLoading = false;
          });
        },
        onNavigationRequest: (NavigationRequest request) async {
          if (!_isLoading) {
            if (request.url.contains(Environment().config.mirrorMediaDomain)) {
              if (!context.read<MemberBloc>().state.shouldShowPremiumUI) {
                AdHelper adHelper = AdHelper();
                adHelper.checkToShowInterstitialAd();
              }
            } else {
              launchUrlString(request.url);
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(url));
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
                child: WebViewWidget(controller: _webViewController),
              );
            },
          ),
        ),
        if (_isLoading)
          Container(
            width: Get.width,
            height: Get.width / _aspectRatio,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator.adaptive()),
          ),
      ],
    );
  }
}
