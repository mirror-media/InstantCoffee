import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/blocs/section/cubit.dart';
import 'package:readr_app/blocs/section/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/appLinkHelper.dart';
import 'package:readr_app/helpers/firebaseMessangingHelper.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/OnBoardingPosition.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/termsOfService/mMTermsOfServicePage.dart';
import 'package:readr_app/pages/tabContent/listening/listeningTabContent.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarquee.dart';
import 'package:readr_app/pages/tabContent/personal/personalTabContent.dart';
import 'package:readr_app/pages/tabContent/news/tabContent.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class HomePage extends StatefulWidget {
  final GlobalKey settingKey;
  HomePage({
    required this.settingKey,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

  final LocalStorage _storage = LocalStorage('setting');
  AppLinkHelper _appLinkHelper = AppLinkHelper();
  FirebaseMessangingHelper _firebaseMessangingHelper = FirebaseMessangingHelper();

  late OnBoardingBloc _onBoardingBloc;

  /// tab controller
  int _initialTabIndex = 0;
  TabController? _tabController;
  StreamController<Color>? _tabColorController;

  List<GlobalKey> _tabKeys = [];
  List<Tab> _tabs = [];
  List<Widget> _tabWidgets = [];
  List<ScrollController> _scrollControllerList = [];

  _fetchSectionList() {
    context.read<SectionCubit>().fetchSectionList();
  }

  @override
  void initState() {
    _fetchSectionList();
    WidgetsBinding.instance!.addObserver(this);
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _appLinkHelper.configAppLink(context);
      _appLinkHelper.listenAppLink(context);
      _firebaseMessangingHelper.configFirebaseMessaging(context);
    });

    _onBoardingBloc = context.read<OnBoardingBloc>();

    _showTermsOfService();
    super.initState();
  }

  _initializeTabController(List<Section> sectionItems) {
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
      if (section.key == Environment().config.listeningSectionKey) {
        _tabWidgets.add(ListeningTabContent(
          section: section,
          scrollController: _scrollControllerList[i],
        ));
      } else if (section.key == Environment().config.personalSectionKey){
        _tabWidgets.add(PersonalTabContent(
          //onBoardingBloc: widget.onBoardingBloc,
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
          _tabController == null ? _initialTabIndex : _tabController!.index,
    )..addListener(() { 
      // when index is member
      if (_tabController!.index == 3) {
        _tabColorController!.sink.add(Color(0xffDB1730));
      } else {
        _tabColorController!.sink.add(appColor);
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{  
      if(_onBoardingBloc.state.isOnBoarding && _onBoardingBloc.state.status == null) {
        // get personal tab size and position by personal tab key(_tabKeys[2])
        OnBoardingPosition onBoardingPosition = await _onBoardingBloc.getSizeAndPosition(_tabKeys[2]);
        onBoardingPosition.left -= 16;
        onBoardingPosition.width += 32;
        onBoardingPosition.function = () {
          _tabController!.animateTo(2);
        };

        _onBoardingBloc.add(
          GoToNextHint(
            onBoardingStatus: OnBoardingStatus.firstPage,
            onBoardingPosition: onBoardingPosition,
          )
        );
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
      bool? isAcceptTerms = await _storage.getItem("isAcceptTerms");
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocBuilder<SectionCubit, SectionState>(
        builder: (BuildContext context, SectionState state) {
          SectionStatus status = state.status;
          if(status == SectionStatus.error) {
            print('HomePageSectionError: ${state.errorMessages}');
            return Container();
          } else if(status == SectionStatus.loaded) {
            _initializeTabController(state.sectionList!);
            return _buildTabs(_tabs, _tabWidgets, _tabController!);
          }

          // init or loading
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      leading: IconButton(
        key: widget.settingKey,
        icon: Icon(Icons.settings),
        onPressed: () => RouteGenerator.navigateToNotificationSettings(
          _onBoardingBloc
        ),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: Text(appTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => RouteGenerator.navigateToSearch(),
        ),
        IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Member',
          onPressed: () => RouteGenerator.navigateToLogin(),
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
              stream: _tabColorController!.stream,
              builder: (context, snapshot) {
                Color tabBarColor = snapshot.data!;

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
        if(_remoteConfigHelper.isNewsMarqueePin)
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
