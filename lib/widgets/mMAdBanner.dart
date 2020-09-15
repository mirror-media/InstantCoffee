import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class MMAdBanner extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;
  MMAdBanner({
    @required this.adUnitId,
    @required this.adSize,
  });

  @override
  _MMAdBannerState createState() => _MMAdBannerState();
}

class _MMAdBannerState extends State<MMAdBanner> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AdmobBanner(
      adUnitId: widget.adUnitId,
      adSize: widget.adSize,
    );
  }
}