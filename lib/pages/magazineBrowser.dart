import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineBrowser extends StatelessWidget {
  final Magazine magazine;
  final String token;
  MagazineBrowser({
    @required this.magazine,
    this.token,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget browser;
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        disableContextMenu: magazine.type == 'weekly',
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        allowContentAccess: magazine.type != 'weekly',
      ),
      ios: IOSInAppWebViewOptions(
        allowsLinkPreview: magazine.type != 'weekly',
        disableLongPressContextMenuOnLinks: magazine.type == 'weekly',
      ),
    );
    if(magazine.type == 'weekly'){
      browser = InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(magazine.onlineReadingUrl),
        ),
        initialOptions: options,
      );
    }else{
      browser = InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(magazine.pdfUrl),
        ),
        initialOptions: options,
      );
    }
    return Scaffold(
      appBar: _buildBar(context),
      body: browser,
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(magazine.issue),
      backgroundColor: appColor,
    );
  }
}