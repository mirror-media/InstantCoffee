import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/home/premium/premium_home_widget.dart';
import 'package:readr_app/pages/login/member_widget/member_widget.dart';
import 'package:readr_app/pages/login/premium_member_widget.dart';
import 'package:readr_app/pages/login/login_widget.dart';
import 'package:readr_app/pages/search/search_page.dart';
import 'package:readr_app/pages/tabContent/news/premium_tab_content.dart';
import 'package:readr_app/services/login_service.dart';
import 'package:readr_app/services/record_service.dart';

import '../home_controller.dart';

class PremiumHomePage extends GetView<HomeController> {
  final GlobalKey settingKey;

  const PremiumHomePage({
    Key? key,
    required this.settingKey,
  }) : super(key: key);

  List<Widget> _getPages(ScrollController premiumArticleBarScrollController) {
    return <Widget>[
      PremiumHomeWidget(),
      const SearchPage(),
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
              scrollController: premiumArticleBarScrollController,
            ),
          )),
      BlocProvider(
        create: (context) => LoginBloc(
          loginRepos: LoginServices(),
          memberBloc: context.read<MemberBloc>(),
          routeName: null,
          routeArguments: null,
        ),
        child: BlocBuilder<MemberBloc, MemberState>(
          builder: (context, memberState) {
            // 判斷用戶狀態
            bool isLoggedIn = memberState.isLogin == true;
            bool isActualPremiumMember = memberState.shouldShowPremiumUI;

            if (isActualPremiumMember) {
              // 真正的付費會員
              return PremiumMemberWidget(
                  israfelId: memberState.israfelId ?? '',
                  subscriptionType:
                      memberState.subscriptionType ?? SubscriptionType.none);
            } else if (isLoggedIn) {
              // 已登入但不是付費會員
              return Container(
                color: Colors.white,
                child: MemberWidget(
                  israfelId: memberState.israfelId ?? '',
                  subscriptionType:
                      memberState.subscriptionType ?? SubscriptionType.none,
                  isNewebpay: false,
                ),
              );
            } else {
              // 未登入用戶
              return Container(
                color: Colors.white,
                child: LoginWidget(),
              );
            }
          },
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        bottom: false,
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _getPages(controller.premiumArticleBarScrollController),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final selectIndex = controller.rxSelectedIndex.value;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: appColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color(0xff1B455C),
          currentIndex: selectIndex,
          onTap: controller.onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜尋'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Premium文章'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '會員中心')
          ],
        );
      }),
    );
  }
}
