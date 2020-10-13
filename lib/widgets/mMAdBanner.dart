import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class MMAdBanner extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;
  final double widthPadding;
  final double leftAndRightPadding;
  MMAdBanner({
    @required this.adUnitId,
    @required this.adSize,
    this.widthPadding = 0,
    this.leftAndRightPadding = 0,
  });

  @override
  _MMAdBannerState createState() => _MMAdBannerState();
}

class _MMAdBannerState extends State<MMAdBanner> with AutomaticKeepAliveClientMixin {
  bool _visible = false;
  double _widthPadding = 0;
  double _padding = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // display specific ad size on iOS
    if(Platform.isIOS) {
      _widthPadding = widget.widthPadding;
      _padding = widget.leftAndRightPadding;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width - 2*_widthPadding;

    return FutureBuilder<bool>(
      // Run this before displaying any ad.
      future: Admob.requestTrackingAuthorization(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Padding(
            padding: EdgeInsets.only(left: _padding, right: _padding),
            child: Container(
              width: width,
              height: width*widget.adSize.height/widget.adSize.width,
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: AdmobBanner(
                  adUnitId: widget.adUnitId,
                  adSize: widget.adSize,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) async{
                    print(event.toString());
                    if(event == AdmobAdEvent.loaded && !_visible && Platform.isAndroid) {
                      //await Future.delayed(Duration(milliseconds: 500));
                      if(mounted) {
                        setState(() {
                          _visible = true;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          );
        }

        return Container();
      }
    );
  }
}