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

  Future<bool> _initAd() async{
    if(Platform.isAndroid) {
      // Prevent the lag of displaying the ad on android.
      await Future.delayed(Duration(milliseconds: 300));
      return true;
    } else if(Platform.isIOS) {
      // Run this before displaying any ad on iOS.
      return await Admob.requestTrackingAuthorization();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width - 2*_widthPadding;

    return FutureBuilder<bool>(
      future: _initAd(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Padding(
            padding: EdgeInsets.only(left: _padding, right: _padding),
            child: Container(
              width: width,
              height: width*widget.adSize.height/widget.adSize.width,
              color: Colors.transparent,
              child: AnimatedOpacityBanner(
                adUnitId: widget.adUnitId,
                adSize: widget.adSize, 
              ),
            ),
          );
        }
        
        if(Platform.isAndroid) {
          return Container(
            width: width,
            height: width*widget.adSize.height/widget.adSize.width,
            color: Colors.transparent,
          );
        }
        return Container();
      }
    );
  }
}

class AnimatedOpacityBanner extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;
  AnimatedOpacityBanner({
    @required this.adUnitId,
    @required this.adSize,
  });

  @override
  _AnimatedOpacityBannerState createState() => _AnimatedOpacityBannerState();
}

class _AnimatedOpacityBannerState extends State<AnimatedOpacityBanner> {
  bool _visible = false;

  @override
  void initState() {
    if(Platform.isIOS) {
      _visible = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
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
    );
  }
}