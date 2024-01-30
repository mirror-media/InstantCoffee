import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/blocs/section/cubit.dart';
import 'package:readr_app/blocs/section/states.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/firebase_analytics_helper.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/models/on_boarding_position.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/tabContent/listening/listening_tab_content.dart';
import 'package:readr_app/pages/tabContent/news/tab_content.dart';
import 'package:readr_app/pages/tabContent/personal/default/personal_tab_content.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page_controller.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/widgets/podcast_sticky_panel/podcast_sticky_panel_controller.dart';
import 'package:readr_app/services/record_service.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/widgets/newsMarquee/news_marquee.dart';
import 'package:readr_app/widgets/popupRoute/easy_popup.dart';
import 'package:readr_app/widgets/popupRoute/section_drop_down_menu.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with TickerProviderStateMixin, Logger {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

  late OnBoardingBloc _onBoardingBloc;

  /// tab controller
  int _initialTabIndex = 0;
  TabController? _tabController;
  StreamController<List<Tab>>? _tabBarController;

  final List<GlobalKey> _tabKeys = [];
  final List<Tab> _tabs = [];
  final List<Widget> _tabWidgets = [];
  final List<ScrollController> _scrollControllerList = [];

  _fetchSectionList() {
    context.read<SectionCubit>().fetchSectionList();
  }

  @override
  void initState() {
    _onBoardingBloc = context.read<OnBoardingBloc>();
    _fetchSectionList();
    super.initState();
  }

  _initializeTabController(List<Section> sectionItems) {
    _tabKeys.clear();
    _tabs.clear();
    _tabWidgets.clear();
    _scrollControllerList.clear();

    int indexToMove =
        sectionItems.indexWhere((section) => section.title == 'Podcasts');

    // 找到 '生活' 的 Section
    int indexAfter =
        sectionItems.indexWhere((section) => section.title == '生活');

    // 如果找到了 'podcast' 和 '生活'，而且 'podcast' 在 '生活' 之前
    if (indexToMove != -1 && indexAfter != -1 && indexToMove < indexAfter) {
      // 取出 'podcast'
      Section sectionToMove = sectionItems.removeAt(indexToMove);

      // 插入到 '生活' 的後面
      sectionItems.insert(indexAfter, sectionToMove);
    }

    for (int i = 0; i < sectionItems.length; i++) {
      _tabKeys.add(GlobalKey());
      Section section = sectionItems[i];
      String title = section.title ?? StringDefault.valueNullDefault;
      Color? color;
      if (section.name == 'member') {
        title = 'Premium文章';
        color = const Color(0xff707070);
      }

      _tabs.add(
        Tab(
          key: _tabKeys[i],
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      );

      _scrollControllerList.add(ScrollController());
      if (section.key == Environment().config.listeningSectionKey) {
        _tabWidgets.add(ListeningTabContent(
          section: section,
          scrollController: _scrollControllerList[i],
        ));
      } else if (section.key == Environment().config.personalSectionKey) {
        _tabWidgets.add(PersonalTabContent(
          //onBoardingBloc: widget.onBoardingBloc,
          scrollController: _scrollControllerList[i],
        ));
      } else if (section.key == 'Podcasts') {
        _tabWidgets.add(const PodcastPage());
      } else {
        _tabWidgets.add(BlocProvider(
            create: (context) => TabContentBloc(recordRepos: RecordService()),
            child: TabContent(
              section: section,
              scrollController: _scrollControllerList[i],
              needCarousel: i == 0,
            )));
      }
    }

    _tabBarController = StreamController<List<Tab>>();

    // set controller
    _tabController = TabController(
      vsync: this,
      length: sectionItems.length,
      initialIndex:
          _tabController == null ? _initialTabIndex : _tabController!.index,
    )..addListener(() {
        _tabs.clear();

        if (sectionItems[_tabController!.index].title == 'Podcasts') {
          if (!Get.isRegistered<PodcastPageController>()) {
            Get.put(PodcastPageController());
          }
          if (!Get.isRegistered<PodcastStickyPanelController>()) {
            Get.put(PodcastStickyPanelController());
          }
        } else {
          if (Get.isRegistered<PodcastPageController>()) {
            final PodcastPageController podcastPageController = Get.find();
            podcastPageController.rxnSelectPodcastInfo.value = null;
            podcastPageController.animationController.reverse();
          }
        }

        for (int i = 0; i < sectionItems.length; i++) {
          Section section = sectionItems[i];
          String title = section.title ?? StringDefault.valueNullDefault;
          Color? color;
          if (section.name == 'member') {
            title = 'Premium文章';
            // when index is member
            if (_tabController!.index == 3) {
              color = appColor;
            } else {
              color = const Color(0xff707070);
            }
          }

          _tabs.add(
            Tab(
              key: _tabKeys[i],
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ),
          );
        }
        _tabBarController!.sink.add(_tabs);
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_onBoardingBloc.state.isOnBoarding &&
          _onBoardingBloc.state.status == null) {
        // get personal tab size and position by personal tab key(_tabKeys[2])
        OnBoardingPosition onBoardingPosition =
            await _onBoardingBloc.getSizeAndPosition(_tabKeys[2]);
        onBoardingPosition.left -= 16;
        onBoardingPosition.width += 32;
        onBoardingPosition.function = () {
          _tabController!.animateTo(2);
        };

        _onBoardingBloc.add(GoToNextHint(
          onBoardingStatus: OnBoardingStatus.firstPage,
          onBoardingPosition: onBoardingPosition,
        ));
      }
    });
  }

  _scrollToTop(int index) {
    if (_scrollControllerList[index].hasClients) {
      _scrollControllerList[index].animateTo(
          _scrollControllerList[index].position.minScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _tabBarController?.close();

    for (var scrollController in _scrollControllerList) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionCubit, SectionState>(
        builder: (BuildContext context, SectionState state) {
      SectionStatus status = state.status;
      if (status == SectionStatus.error) {
        debugLog('HomePageSectionError: ${state.errorMessages}');
        return Container();
      } else if (status == SectionStatus.loaded) {
        _initializeTabController(state.sectionList!);

        return _buildTabs(
            state.sectionList!, _tabs, _tabWidgets, _tabController!);
      }

      // init or loading
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildTabs(List<Section> sections, List<Tab> tabs,
      List<Widget> tabWidgets, TabController tabController) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: Material(
            color: const Color.fromARGB(255, 229, 229, 229),
            child: StreamBuilder<List<Tab>>(
                initialData: tabs,
                stream: _tabBarController!.stream,
                builder: (context, snapshot) {
                  List<Tab> tabs = snapshot.data!;
                  TabBar tabBar = TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicatorColor: appColor,
                    unselectedLabelColor: const Color(0xffA3A3A3),
                    labelColor: appColor,
                    tabs: tabs.toList(),
                    controller: tabController,
                    onTap: (int index) {
                      if (index >= 5) {
                        FirebaseAnalyticsHelper.logTabBarAfterTheSixthClick(
                            sectiontitle: sections[index].title ??
                                StringDefault.valueNullDefault);
                      }

                      if (_initialTabIndex == index) {
                        _scrollToTop(index);
                      }
                      _initialTabIndex = index;
                    },
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: tabBar,
                      ),
                      if (_remoteConfigHelper.hasTabSectionButton) ...[
                        SizedBox(
                          height: tabBar.preferredSize.height,
                          child: const VerticalDivider(
                            color: Colors.black12,
                            thickness: 1,
                            indent: 12,
                            endIndent: 12,
                            width: 8,
                          ),
                        ),
                        InkWell(
                            child: SizedBox(
                              height: tabBar.preferredSize.height,
                              width: tabBar.preferredSize.height - 8,
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              EasyPopup.show(
                                context,
                                SectionDropDownMenu(
                                  topPadding: kToolbarHeight,
                                  tabBarHeight: tabBar.preferredSize.height,
                                  tabController: _tabController!,
                                  sectionList: sections,
                                ),
                                hasPaddingTop: true,
                                offsetLT: const Offset(
                                  0,
                                  kToolbarHeight,
                                ),
                                cancelable: true,
                                outsideTouchCancelable: false,
                              );
                            })
                      ]
                    ],
                  );
                }),
          ),
        ),
        if (_remoteConfigHelper.isNewsMarqueePin) NewsMarquee(),
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
