import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class MMAdBanner extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;
  final bool isKeepAlive;
  MMAdBanner({
    @required this.adUnitId,
    @required this.adSize,
    this.isKeepAlive = false,
  });

  @override
  _MMAdBannerState createState() => _MMAdBannerState();
}

class _MMAdBannerState extends State<MMAdBanner> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => widget.isKeepAlive;

  Future<bool> _initAd() async{
    if(Platform.isAndroid) {
      // Prevent the lag of displaying the ad on android.
      await Future.delayed(Duration(milliseconds: 250));
      return true;
    } else if(Platform.isIOS) {
      // Run this before displaying any ad on iOS,
      await Admob.requestTrackingAuthorization();
      return true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<bool>(
      future: _initAd(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Container(
            width: widget.adSize.width.toDouble(),
            height: widget.adSize.height.toDouble(),
            color: Colors.transparent,
            child: AnimatedOpacityBanner(
              adUnitId: widget.adUnitId,
              adSize: widget.adSize, 
            ),
          );
        }
        
        if(Platform.isAndroid) {
          return Container(
            width: widget.adSize.width.toDouble(),
            height: widget.adSize.height.toDouble(),
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
      duration: Duration(milliseconds: 250),
      child: AdmobBanner(
        adUnitId: widget.adUnitId,
        adSize: widget.adSize,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) async{
          // print(event.toString());
          // print(args.toString());
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