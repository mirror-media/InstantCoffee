import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWidget extends StatefulWidget {
  final String youtubeId;
  final String? description;
  final double width;

  const YoutubeWidget({
    required this.width,
    required this.youtubeId,
    this.description,
  });

  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget>
    with AutomaticKeepAliveClientMixin {
  bool _visible = false;
  late final WebViewController _webViewController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              _visible = true;
            });
          },
          onWebResourceError: (error) {
            // Handle error
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://www.youtube.com/embed/${widget.youtubeId}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            width: widget.width,
            height: widget.width / 16 * 9,
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
        ),
        if (widget.description != null && widget.description != '')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.description!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
