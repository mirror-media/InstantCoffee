import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/root_page/root_controller.dart';
import 'package:readr_app/routes/pages.dart';
import 'package:readr_app/routes/routes.dart';

class RootPage extends GetView<RootController> with WidgetsBindingObserver {

  const RootPage({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: Get.nestedKey(Routes.navigationKey),
          initialRoute: Routes.home,
          onGenerateRoute: Pages.onGenerateRoute,
        ),
        bottomNavigationBar: Obx(() {
          final currentNavigationPage =
              controller.rxCurrentNavigationPage.value;
          final isPremium =
              controller.authProvider.rxnMemberInfo.value?.isPremiumMember;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: isPremium == true ? Colors.black : appColor,
            unselectedItemColor: Colors.white,
            selectedItemColor: isPremium == true ? appColor : Colors.white,
            currentIndex: currentNavigationPage.index,
            onTap: controller.onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜尋'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark), label: '個人書籤'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: '會員文章'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '會員中心')
            ],
          );
        }),
      ),
    );
  }
}
