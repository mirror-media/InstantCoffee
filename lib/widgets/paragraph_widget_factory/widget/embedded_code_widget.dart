import 'package:flutter/material.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import 'package:flutter_embedded_webview/src/embeddedCodeType.dart';
import 'package:flutter_embedded_webview/src/platform/facebookEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/generalEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/googleDocsEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/googleFormsEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/googleMapEmbeddedWidget.dart';
import 'package:flutter_embedded_webview/src/platform/googleSpreadsheetsEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/instagramEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/tiktokEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/twitterEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/ytEmbeddedCodeWidget.dart';
import 'package:flutter_embedded_webview/src/platform/dcardEmbeddedCodeWidget.dart';

class EmbeddedCodeWidget extends StatelessWidget {

  final Paragraph paragraph;
  const EmbeddedCodeWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String embeddedCode = paragraph.contents![0].data??'';
    double aspectRatio = paragraph.contents![0].aspectRatio??1.0;
    EmbeddedCodeType? _embeddedCodeType = EmbeddedCode.findEmbeddedCodeType(embeddedCode);

    switch (_embeddedCodeType) {
      case EmbeddedCodeType.facebook:
        return FacebookEmbeddedCodeWidget(embeddedCode: embeddedCode);
      case EmbeddedCodeType.instagram:
        return InstagramEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.twitter:
        return TwitterEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.tiktok:
        return TiktokEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.dcard:
        return DcardEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.googleForms:
        return GoogleFormsEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.googleMap:
        return GoogleMapEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.youtube:
        return YtEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
          aspectRatio: aspectRatio,
        );
      case EmbeddedCodeType.googleDocs:
        return GoogleDocsEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      case EmbeddedCodeType.googleSpreadsheets:
        return GoogleSpreadsheetsEmbeddedCodeWidget(
          embeddedCode: embeddedCode,
        );
      default:
        return GeneralEmbeddedCodeWidget(embeddedCode: embeddedCode);
    }
  }
}
