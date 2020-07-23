import 'package:flutter/material.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionService.dart';
import 'package:readr_app/widgets/newsMarquee.dart';
import 'package:readr_app/widgets/tabContent.dart';

import 'notificationSettingsPage.dart';
import 'helpers/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<ScrollController> _scrollControllerList;

  // tab text
  SectionList _sectionItems;

  /// tab controller
  int initialTabIndex = 0;
  TabController _tabController;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabWidgets = List<Widget>();

  @override
  void initState() {
    _scrollControllerList = List<ScrollController>();

    _loadingData();
    super.initState();
  }

  _loadingData() async {
    await _setSections();
    _initializeTabController();
  }

  Future<void> _setSections() async {
    SectionList resultSectionList = SectionList();
    SectionList allSections = SectionList();
    allSections = await SectionService().loadSections();
    for (Section section in allSections) {
      resultSectionList.add(section);
    }

    setState(() {
      _sectionItems = resultSectionList;
    });
  }

  void _initializeTabController() {
    _tabs.clear();
    _tabWidgets.clear();

    for (int i = 0; i < _sectionItems.length; i++) {
      Section section = _sectionItems[i];
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

      _tabWidgets.add(TabContent(
        section: section,
        scrollController: _scrollControllerList[i],
        needCarousel: i == 0,
      ));
    }

    // set controller
    _tabController = TabController(
      vsync: this,
      length: _sectionItems.length,
      initialIndex:
          _tabController == null ? initialTabIndex : _tabController.index,
    );
  }

  _scrollToTop(int index) {
    if(_scrollControllerList[index].hasClients)
    {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: _sectionItems == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 150.0),
                  child: Material(
                    color: Color.fromARGB(255, 229, 229, 229),
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      tabs: _tabs.toList(),
                      controller: _tabController,
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
                    controller: _tabController,
                    children: _tabWidgets.toList(),
                  ),
                ),
              ],
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
}
