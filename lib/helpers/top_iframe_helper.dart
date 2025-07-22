import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TopIframeHelper {
  static const String _heightDetectionScript = '''
    (function() {
      try {
        // 移除不必要的空白元素
        var emptyElements = document.querySelectorAll('div:empty, p:empty, span:empty');
        for (var i = 0; i < emptyElements.length; i++) {
          var elem = emptyElements[i];
          if (elem.offsetHeight === 0 && elem.offsetWidth === 0) {
            elem.style.display = 'none';
          }
        }
        
        // 檢測實際內容高度
        var body = document.body;
        var html = document.documentElement;
        
        // 找到所有有內容的元素，包含表格和圖片
        var elements = document.querySelectorAll('table, div, p, span, h1, h2, h3, h4, h5, h6, img, canvas, svg');
        var maxBottom = 0;
        var minTop = Infinity;
        
        for (var i = 0; i < elements.length; i++) {
          var element = elements[i];
          var rect = element.getBoundingClientRect();
          var computedStyle = window.getComputedStyle(element);
          
          // 跳過隱藏的元素
          if (computedStyle.display === 'none' || computedStyle.visibility === 'hidden') {
            continue;
          }
          
          // 只考慮可見且有內容的元素
          if (rect.height > 0 && rect.width > 0) {
            var top = rect.top + window.pageYOffset;
            var bottom = rect.bottom + window.pageYOffset;
            
            if (top < minTop) {
              minTop = top;
            }
            if (bottom > maxBottom) {
              maxBottom = bottom;
            }
          }
        }
        
        // 計算實際內容高度
        var contentHeight = maxBottom - Math.max(0, minTop);
        
        // 如果找到內容，使用實際高度；否則使用文檔高度
        if (contentHeight > 0 && maxBottom > 0) {
          return Math.min(contentHeight + 3, 500);
        } else {
          // 備用方法：使用文檔高度
          var docHeight = Math.max(
            body.scrollHeight, body.offsetHeight,
            html.clientHeight, html.scrollHeight, html.offsetHeight
          );
          return Math.min(docHeight, 500);
        }
      } catch (e) {
        return 300; // 發生錯誤時返回預設值
      }
    })();
  ''';

  static InAppWebViewSettings createWebViewSettings() {
    return InAppWebViewSettings(
      javaScriptEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      transparentBackground: true,
      supportZoom: false,
      builtInZoomControls: false,
      displayZoomControls: false,
      useOnLoadResource: true,
      clearCache: false,
      cacheMode: CacheMode.LOAD_DEFAULT,
      useShouldOverrideUrlLoading: true,
      allowsBackForwardNavigationGestures: false,
      allowsLinkPreview: false,
      isFraudulentWebsiteWarningEnabled: false,
      allowUniversalAccessFromFileURLs: true,
      allowFileAccessFromFileURLs: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    );
  }

  static Future<double?> detectHeight(InAppWebViewController controller) async {
    try {
      final result =
          await controller.evaluateJavascript(source: _heightDetectionScript);
      if (result != null && result > 0) {
        double jsHeight = double.tryParse(result.toString()) ?? 0;
        if (jsHeight > 100) {
          return jsHeight > 500 ? 500 : jsHeight;
        }
      }
    } catch (e) {}
    return null;
  }

  static String generateWebViewKey(String url) {
    return '${url}_${DateTime.now().millisecondsSinceEpoch}';
  }

  static bool shouldUpdateHeight(double currentHeight, double newHeight) {
    return (newHeight - currentHeight).abs() > 10;
  }

  static double calculateContentHeight(double contentHeight) {
    if (contentHeight <= 0) return 300;
    return contentHeight > 500 ? 500 : contentHeight;
  }

  static void safeDisposeWebView(InAppWebViewController? controller) {
    if (controller != null) {
      try {
        controller.dispose();
      } catch (e) {}
    }
  }
}
