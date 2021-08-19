import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MMAdBanner extends StatefulWidget {
  final String adUnitId;
  final AdSize adSize;
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
  bool _loadingAnchoredBanner = false;
  
  static final AdRequest request = AdRequest();

  BannerAd _anchoredBanner;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final BannerAd banner = BannerAd(
      size: widget.adSize,
      request: request,
      adUnitId: widget.adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredBanner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
      ),
    );
    return banner.load();
  }

  @override
  bool get wantKeepAlive => widget.isKeepAlive;

  @override
  void dispose() {
    super.dispose();
    _anchoredBanner?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Builder(builder: (BuildContext context) {
      if (!_loadingAnchoredBanner) {
        _loadingAnchoredBanner = true;
        _createAnchoredBanner(context);
      }
      
      if (_anchoredBanner != null) {
        return Container(
          color: Colors.transparent,
          width: _anchoredBanner.size.width.toDouble(),
          height: _anchoredBanner.size.height.toDouble(),
          child: AdWidget(ad: _anchoredBanner),
        );
      }

      return Container(
        color: Colors.transparent,
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
      );
    });
  }
}