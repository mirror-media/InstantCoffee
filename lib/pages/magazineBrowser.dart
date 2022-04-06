import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineBrowser extends StatefulWidget {
  final Magazine magazine;
  MagazineBrowser({
    required this.magazine,
  });

  @override
  State<MagazineBrowser> createState() => _MagazineBrowserState();
}

class _MagazineBrowserState extends State<MagazineBrowser> {
  late Widget _browser;

  void _setBrowser(String type) {
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        disableContextMenu: type == 'weekly',
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        allowContentAccess: type != 'weekly',
      ),
      ios: IOSInAppWebViewOptions(
        allowsLinkPreview: type != 'weekly',
        disableLongPressContextMenuOnLinks: type == 'weekly',
      ),
    );

    if(type == 'weekly'){
      _browser = InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.magazine.onlineReadingUrl),
        ),
        initialOptions: options,
      );
    } else{
      _browser = InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.magazine.pdfUrl),
        ),
        initialOptions: options,
      );
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _setBrowser(widget.magazine.type);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation  == Orientation.portrait) {
          return Scaffold(
            appBar: _buildBar(context),
            body: _browser,
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              _browser,
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: Container(
                        color: Colors.black45,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop()
                    ),             
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop()
      ),
      centerTitle: true,
      title: Text(widget.magazine.issue),
      backgroundColor: appColor,
    );
  }
}