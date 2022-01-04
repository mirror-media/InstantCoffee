import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/magazine/specialMagazineWidget.dart';
import 'package:readr_app/pages/magazine/weeklyMagazineWidget.dart';
import 'package:readr_app/pages/magazine/onlineMagazineWidget.dart';
import 'package:readr_app/services/magazineService.dart';

class MagazinePage extends StatefulWidget {
  final SubscriptionType subscriptionType;
  MagazinePage({
    @required this.subscriptionType,
  });

  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  ScrollController _listviewController = ScrollController();
  
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
              create: (context) => MagazineBloc(magazineRepos: MagazineServices()),
              child: WeeklyMagazineWidget(),
            ),
            OnlineMagazineWidget(),
            BlocProvider(
              create: (context) => MagazineBloc(magazineRepos: MagazineServices()),
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
            Text(
              '加入Premium會員，免費閱覽最新電子版週刊',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 17,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: appColor),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      '升級 Premium 會員',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onPressed: () => RouteGenerator.navigateToSubscriptionSelect(),
              ),
            ),
          ],
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
      title: Text('電子雜誌'),
      backgroundColor: appColor,
    );
  }
}