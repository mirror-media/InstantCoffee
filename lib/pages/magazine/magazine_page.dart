import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/magazine/special_magazine_widget.dart';
import 'package:readr_app/pages/magazine/weekly_magazine_widget.dart';
import 'package:readr_app/pages/magazine/online_magazine_widget.dart';
import 'package:readr_app/services/magazine_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MagazinePage extends StatefulWidget {
  final SubscriptionType subscriptionType;
  final bool showAppBar;

  const MagazinePage({
    super.key,
    required this.subscriptionType,
    this.showAppBar = true, // 預設顯示 AppBar
  });

  @override
  State<MagazinePage> createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  final ScrollController _listviewController = ScrollController();

  bool _checkPermission(SubscriptionType subscriptionType) {
    return subscriptionType == SubscriptionType.subscribe_monthly ||
        subscriptionType == SubscriptionType.subscribe_yearly ||
        subscriptionType == SubscriptionType.marketing ||
        subscriptionType == SubscriptionType.staff;
  }

  @override
  void dispose() {
    _listviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPermission = _checkPermission(widget.subscriptionType);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar ? _buildBar(context) : null,
      body: Stack(
        children: [
          ListView(
            controller: _listviewController,
            children: [
              BlocProvider(
                create: (context) =>
                    MagazineBloc(magazineRepos: MagazineServices()),
                child: WeeklyMagazineWidget(),
              ),
              BlocProvider(
                create: (context) =>
                    MagazineBloc(magazineRepos: MagazineServices()),
                child: SpecialMagazineWidget(
                  listviewController: _listviewController,
                ),
              ),
              OnlineMagazineWidget(),
            ],
          ),
          if (!hasPermission)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '加入 Premium 會員，免費線上閱讀動態雜誌',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 17,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                        ),
                        onPressed: () => launchUrl(
                          Uri.parse(Environment().config.subscriptionLink),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              '升級 Premium 會員',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('動態雜誌'),
      backgroundColor: appColor,
    );
  }
}
