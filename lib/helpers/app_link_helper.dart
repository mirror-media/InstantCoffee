import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:readr_app/helpers/route_generator.dart';

class AppLinkHelper {
  final AppLinks _appLinks = AppLinks();
  bool _hasHandledInitialLink = false;

  AppLinkHelper();

  // 監聽 deep link
  void listenAppLink(BuildContext context) {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (!_hasHandledInitialLink) {
          // 預設第一次就是 initial
          _hasHandledInitialLink = true;
          _handleUri(context, uri);
        } else {
          // 之後的就是背景或已開啟時觸發
          _handleUri(context, uri);
        }
      }
    }, onError: (err) {
      debugPrint('❌ uriLinkStream error: $err');
    });
  }

  void _handleUri(BuildContext context, Uri uri) {
    final segments = uri.pathSegments;
    for (int i = 0; i < segments.length; i++) {
      if (segments[i] == 'story' && i + 1 < segments.length) {
        _navigateToStoryPage(context, segments[i + 1]);
        break;
      } else if (segments[i] == 'video' && i + 1 < segments.length) {
        _navigateToStoryPage(context, segments[i + 1], isListeningPage: true);
        break;
      }
    }
  }

  void _navigateToStoryPage(BuildContext context, String? slug,
      {bool isListeningPage = false}) {
    if (slug != null && slug.isNotEmpty) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      if (isListeningPage) {
        RouteGenerator.navigateToListeningStory(slug);
      } else {
        RouteGenerator.navigateToStory(slug);
      }
    }
  }
}