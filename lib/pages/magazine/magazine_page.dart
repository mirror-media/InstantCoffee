import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/magazine/special_magazine_widget.dart';
import 'package:readr_app/pages/magazine/weekly_magazine_widget.dart';
import 'package:readr_app/pages/magazine/online_magazine_widget.dart';
import 'package:readr_app/services/magazine_service.dart';

class MagazinePage extends StatefulWidget {
  final SubscriptionType subscriptionType;
  const MagazinePage({
    required this.subscriptionType,
  });

  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  final ScrollController _listviewController = ScrollController();

  bool _checkPermission(SubscriptionType subscriptionType) {
    return widget.subscriptionType == SubscriptionType.subscribe_monthly ||
        widget.subscriptionType == SubscriptionType.subscribe_yearly ||
        widget.subscriptionType == SubscriptionType.marketing ||
        widget.subscriptionType == SubscriptionType.staff;
  }

  @override
  void dispose() {
    _listviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildBar(context),
      body: _checkPermission(widget.subscriptionType)
          ? ListView(
              controller: _listviewController,
              children: [
                BlocProvider(
                  create: (context) =>
                      MagazineBloc(magazineRepos: MagazineServices()),
                  child: WeeklyMagazineWidget(),
                ),
                OnlineMagazineWidget(),
                BlocProvider(
                  create: (context) =>
                      MagazineBloc(magazineRepos: MagazineServices()),
                  child: SpecialMagazineWidget(
                    listviewController: _listviewController,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '加入Premium會員，免費線上閱讀動態雜誌',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 17,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appColor),
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
                    onPressed: () =>
                        RouteGenerator.navigateToSubscriptionSelect(),
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
      title: const Text('電子雜誌'),
      backgroundColor: appColor,
    );
  }
}
