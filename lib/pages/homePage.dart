import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/blocs/sectionBloc.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/appLinkHelper.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/firebaseMessangingHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/termsOfService/mMTermsOfServicePage.dart';
import 'package:readr_app/widgets/listeningTabContent.dart';
import 'package:readr_app/widgets/newsMarquee.dart';
import 'package:readr_app/widgets/personalWidget.dart';
import 'package:readr_app/widgets/tabContent.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class HomePage extends StatefulWidget {
  final GlobalKey settingKey;
  final OnBoardingBloc onBoardingBloc;
  final bool isUpdateAvailable;
  HomePage({
    @required this.settingKey,
    @required this.onBoardingBloc,
    this.isUpdateAvailable = false,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  final LocalStorage _storage = LocalStorage('setting');
  AppUpgradeHelper _appUpgradeHelper;
  AppLinkHelper _appLinkHelper;
  FirebaseMessangingHelper _firebaseMessangingHelper;

  SectionBloc _sectionBloc;

  /// tab controller
  int _initialTabIndex;
  TabController _tabController;
  StreamController<Color> _tabColorController;

  List<GlobalKey> _tabKeys;
  List<Tab> _tabs;
  List<Widget> _tabWidgets;
  List<ScrollController> _scrollControllerList;

  @override
  void initState() {
    _appUpgradeHelper = AppUpgradeHelper();
    _appLinkHelper = AppLinkHelper();
    _firebaseMessangingHelper = FirebaseMessangingHelper();

    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _appLinkHelper.configAppLink(context);
      _appLinkHelper.listenAppLink(context);
      _firebaseMessangingHelper.configFirebaseMessaging(context);
      if(widget.isUpdateAvailable){
        _appUpgradeHelper.renderUpgradeUI(context);
      }
    });

    _sectionBloc = SectionBloc();

    /// tab controller
    _initialTabIndex = 0;
    _tabKeys = List<GlobalKey>();
    _tabs = List<Tab>();
    _tabWidgets = List<Widget>();
    _scrollControllerList = List<ScrollController>();
    _showTermsOfService();
    super.initState();
  }

  _initializeTabController(SectionList sectionItems) {
    _tabKeys.clear();
    _tabs.clear();
    _tabWidgets.clear();
    _scrollControllerList.clear();

    for (int i = 0; i < sectionItems.length; i++) {
      _tabKeys.add(GlobalKey());
      Section section = sectionItems[i];
      _tabs.add(
        Tab(
          key: _tabKeys[i],
          child: Text(
            section.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: section.name == 'member'
              ? Color(0xffDB1730)
              : null,
            ),
          ),
        ),
      );

      _scrollControllerList.add(ScrollController());
      if (section.key == env.baseConfig.listeningSectionKey) {
        _tabWidgets.add(ListeningTabContent(
          section: section,
          scrollController: _scrollControllerList[i],
        ));
      } else if (section.key == env.baseConfig.personalSectionKey){
        _tabWidgets.add(PersonalWidget(
          onBoardingBloc: widget.onBoardingBloc,
          scrollController: _scrollControllerList[i],
        ));
      } else {
        _tabWidgets.add(TabContent(
          section: section,
          scrollController: _scrollControllerList[i],
          needCarousel: i == 0,
        ));
      }
    }

    _tabColorController = StreamController<Color>();

    // set controller
    _tabController = TabController(
      vsync: this,
      length: sectionItems.length,
      initialIndex:
          _tabController == null ? _initialTabIndex : _tabController.index,
    )..addListener(() { 
      // when index is member
      if (_tabController.index == 3) {
        _tabColorController.sink.add(Color(0xffDB1730));
      } else {
        _tabColorController.sink.add(appColor);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{  
      if(widget.onBoardingBloc.isOnBoarding && 
      widget.onBoardingBloc.status == OnBoardingStatus.FirstPage) {
        // get personal tab size and position by personal tab key(_tabKeys[2])
        OnBoarding onBoarding = await widget.onBoardingBloc.getSizeAndPosition(_tabKeys[2]);
        onBoarding.left -= 16;
        onBoarding.width += 32;
        onBoarding.isNeedInkWell = true;
        onBoarding.function = () {
          _tabController.animateTo(2);
        };

        widget.onBoardingBloc.closeFunction = () {
          _tabController.animateTo(0);
        };
        widget.onBoardingBloc.checkOnBoarding(onBoarding);
        widget.onBoardingBloc.status = OnBoardingStatus.SecondPage;
      }
    });
  }

  _scrollToTop(int index) {
    if (_scrollControllerList[index].hasClients) {
      _scrollControllerList[index].animateTo(
          _scrollControllerList[index].position.minScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }
  }

  _showTermsOfService() async{
    if(await _storage.ready) {
      bool isAcceptTerms = await _storage.getItem("isAcceptTerms");
      if(isAcceptTerms == null || !isAcceptTerms) {
        _storage.setItem("isAcceptTerms", false);
        await Future.delayed(Duration(seconds: 1));
        await Navigator.of(context).push(
          PageRouteBuilder(
            barrierDismissible: false,
            pageBuilder: (BuildContext context, _, __) => MMTermsOfServicePage()
          )
        );
      }
    }
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessangingHelper.dispose();
    _tabController?.dispose();
    _tabColorController?.close();

    _scrollControllerList.forEach((scrollController) {
      scrollController.dispose();
    });

    _sectionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<SectionList>>(
        stream: _sectionBloc.sectionListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                SectionList sectionList = snapshot.data.data;
                _initializeTabController(sectionList);

                return _buildTabs(_tabs, _tabWidgets, _tabController);
                break;

              case Status.ERROR:
                return Container();
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      leading: IconButton(
        key: widget.settingKey,
        icon: Icon(Icons.settings),
        onPressed: () => RouteGenerator.navigateToNotificationSettings(
          context, 
          widget.onBoardingBloc
        ),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: Text(appTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => RouteGenerator.navigateToSearch(context),
        ),
        IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Member',
          onPressed: () => RouteGenerator.navigateToLogin(context),
        ),
      ],
    );
  }

  Widget _buildTabs(
      List<Tab> tabs, List<Widget> tabWidgets, TabController tabController) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 150.0),
          child: Material(
            color: Color.fromARGB(255, 229, 229, 229),
            child: StreamBuilder<Color>(
              initialData: appColor,
              stream: _tabColorController.stream,
              builder: (context, snapshot) {
                Color tabBarColor = snapshot.data;

                return TabBar(
                  isScrollable: true,
                  indicatorColor: tabBarColor,
                  unselectedLabelColor: Colors.grey,
                  labelColor: appColor,
                  tabs: tabs.toList(),
                  controller: tabController,
                  onTap: (int index) {
                    if (_initialTabIndex == index) {
                      _scrollToTop(index);
                    }
                    _initialTabIndex = index;
                  },
                );
              }
            ),
          ),
        ),
        NewsMarquee(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabWidgets.toList(),
          ),
        ),
      ],
    );
  }
}
