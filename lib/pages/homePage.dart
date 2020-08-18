import 'package:flutter/material.dart';
import 'package:readr_app/blocs/sectionBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/widgets/listingTabContent.dart';
import 'package:readr_app/widgets/newsMarquee.dart';
import 'package:readr_app/widgets/tabContent.dart';

import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/helpers/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<ScrollController> _scrollControllerList;
  SectionBloc _sectionBloc;

  /// tab controller
  int initialTabIndex = 0;
  TabController _tabController;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabWidgets = List<Widget>();

  @override
  void initState() {
    _scrollControllerList = List<ScrollController>();
    _sectionBloc = SectionBloc();
    super.initState();
  }

  _initializeTabController(SectionList sectionItems) {
    _tabs.clear();
    _tabWidgets.clear();

    for (int i = 0; i < sectionItems.length; i++) {
      Section section = sectionItems[i];
      _tabs.add(
        Tab(
          child: Text(
            section.title,
            style: TextStyle(
              fontWeight: FontWeight.bold, /*fontSize: 20.0*/
            ),
          ),
        ),
      );

      _scrollControllerList.add(ScrollController());
      if(section.key == '5975ab2de531830d00e32b2f') {
        _tabWidgets.add(ListingTabContent(
          section: section,
          scrollController: _scrollControllerList[i],
        ));
      }
      else {
        _tabWidgets.add(TabContent(
          section: section,
          scrollController: _scrollControllerList[i],
          needCarousel: i == 0,
        ));
      }
    }

    // set controller
    _tabController = TabController(
      vsync: this,
      length: sectionItems.length,
      initialIndex:
          _tabController == null ? initialTabIndex : _tabController.index,
    );
  }

  _scrollToTop(int index) {
    if (_scrollControllerList[index].hasClients) {
      _scrollControllerList[index].animateTo(
          _scrollControllerList[index].position.minScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();

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
        icon: Icon(Icons.settings),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationSettingsPage(),
            fullscreenDialog: true,
          ),
        ),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: Text(appTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => {},
        ),
        IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Personal',
          onPressed: () => {},
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
            child: TabBar(
              isScrollable: true,
              indicatorColor: appColor,
              unselectedLabelColor: Colors.grey,
              labelColor: appColor,
              tabs: tabs.toList(),
              controller: tabController,
              onTap: (int index) {
                if (initialTabIndex == index) {
                  _scrollToTop(index);
                }
                initialTabIndex = index;
              },
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
