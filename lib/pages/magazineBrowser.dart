import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MagazineBrowser extends StatelessWidget {
  final Magazine magazine;
  MagazineBrowser({
    @required this.magazine
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: WebView(
        initialUrl: magazine.pdfUrl,
      ),
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