import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/search/cubit.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/helpers/app_link_helper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/firebase_messaging_helper.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/home/premium/premium_home_widget.dart';
import 'package:readr_app/pages/login/premium_member_widget.dart';
import 'package:readr_app/pages/search/search_widget.dart';
import 'package:readr_app/pages/tabContent/news/premium_tab_content.dart';
import 'package:readr_app/pages/termsOfService/m_m_terms_of_service_page.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/services/record_service.dart';
import 'package:readr_app/services/search_service.dart';

class PremiumHomePage extends StatefulWidget {
  final GlobalKey settingKey;
  const PremiumHomePage({
    required this.settingKey,
  });

  @override
  _PremiumHomePageState createState() => _PremiumHomePageState();
}

class _PremiumHomePageState extends State<PremiumHomePage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late PageController _pageController;
  final ScrollController _premeniumArticleBarScrollController =
      ScrollController();

  final LocalStorage _storage = LocalStorage('setting');
  final AppLinkHelper _appLinkHelper = AppLinkHelper();
  final FirebaseMessangingHelper _firebaseMessangingHelper =
      FirebaseMessangingHelper();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _appLinkHelper.configAppLink(context);
      _appLinkHelper.listenAppLink(context);
      _firebaseMessangingHelper.configFirebaseMessaging();
    });
    _pageController = PageController(initialPage: _selectedIndex);
    _showTermsOfService();
    super.initState();
  }

  List<Widget> _getPages(ScrollController premeniumArticleBarScrollController) {
    return <Widget>[
      PremiumHomeWidget(),
      BlocProvider(
        create: (context) => SearchCubit(searchRepos: SearchServices()),
        child: ColoredBox(color: Colors.white, child: SearchWidget()),
      ),
      ColoredBox(
          color: Colors.white,
          child: BlocProvider(
            create: (context) => TabContentBloc(recordRepos: RecordService()),
            child: PremiumTabContent(
              section: Section(
                key: Environment().config.memberSectionKey,
                name: 'member',
                title: '會員專區',
                description: '',
                order: 0,
                focus: false,
                type: 'section',
              ),
              scrollController: premeniumArticleBarScrollController,
            ),
          )),
      PremiumMemberWidget(
          israfelId: context.read<MemberBloc>().state.israfelId!,
          subscriptionType: context.read<MemberBloc>().state.subscriptionType!)
    ];
  }

  _showTermsOfService() async {
    if (await _storage.ready) {
      bool? isAcceptTerms = await _storage.getItem("isAcceptTerms");
      if (isAcceptTerms == null || !isAcceptTerms) {
        _storage.setItem("isAcceptTerms", false);
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.of(context).push(PageRouteBuilder(
            barrierDismissible: false,
            pageBuilder: (BuildContext context, _, __) =>
                MMTermsOfServicePage()));
      }
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && _selectedIndex == 2) {
      _premeniumArticleBarScrollController.animateTo(
          _premeniumArticleBarScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessangingHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        bottom: false,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _getPages(_premeniumArticleBarScrollController),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: appColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color(0xff1B455C),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜尋'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Premium文章'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '會員中心')
        ],
      ),
    );
  }
}
