import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookIframeWidget extends StatefulWidget {
  @override
  State<FacebookIframeWidget> createState() => _FacebookIframeWidgetState();
}

class _FacebookIframeWidgetState extends State<FacebookIframeWidget>
    with AutomaticKeepAliveClientMixin {
  final String iframe =
      '<html><body><iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2Fmirrormediamg&tabs&width=340&height=130&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId=2138298816406811" width="340" height="130" style="border:none;overflow:hidden;transform: scale(2.85);transform-origin:0 0;" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe></body></html>';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 14),
      height: 160,
      child: WebView(
        initialUrl:
            Uri.dataFromString(iframe, mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,
      ),
    );
  }
}
