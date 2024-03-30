// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:readr_app/blocs/member/bloc.dart';
// import 'package:readr_app/blocs/search/cubit.dart';
// import 'package:readr_app/blocs/tabContent/bloc.dart';
// import 'package:readr_app/core/values/colors.dart';
// import 'package:readr_app/helpers/environment.dart';
// import 'package:readr_app/models/section.dart';
// import 'package:readr_app/pages/home/premium/premium_home_widget.dart';
// import 'package:readr_app/pages/login/premium_member_widget.dart';
// import 'package:readr_app/pages/search/search_widget.dart';
// import 'package:readr_app/pages/tabContent/news/premium_tab_content.dart';
// import 'package:readr_app/services/record_service.dart';
// import 'package:readr_app/services/search_service.dart';
//
// import '../../root_page/root_controller.dart';
//
// class PremiumHomePage extends GetView<RootController> {
//   final GlobalKey settingKey;
//
//   const PremiumHomePage({
//     Key? key,
//     required this.settingKey,
//   }) : super(key: key);
//
//   List<Widget> _getPages(ScrollController premiumArticleBarScrollController) {
//     return <Widget>[
//       PremiumHomeWidget(),
//       BlocProvider(
//         create: (context) => SearchCubit(searchRepos: SearchServices()),
//         child: ColoredBox(color: Colors.white, child: SearchWidget()),
//       ),
//       ColoredBox(
//           color: Colors.white,
//           child: BlocProvider(
//             create: (context) => TabContentBloc(recordRepos: RecordService()),
//             child: PremiumTabContent(
//               section: Section(
//                 key: Environment().config.memberSectionKey,
//                 name: 'member',
//                 title: '會員專區',
//                 description: '',
//                 order: 0,
//                 focus: false,
//                 type: 'section',
//               ),
//               scrollController: premiumArticleBarScrollController,
//             ),
//           )),
//       // PremiumMemberWidget(
//       //     israfelId: controller.context!.read<MemberBloc>().state.israfelId!,
//       //     subscriptionType:
//       //         controller.context!.read<MemberBloc>().state.subscriptionType!)
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appColor,
//       body: SafeArea(
//         bottom: false,
//         child: PageView(
//           controller: controller.pageController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: _getPages(controller.premiumArticleBarScrollController),
//         ),
//       ),
//       bottomNavigationBar: Obx(() {
//         final selectIndex =controller.rxSelectedIndex.value;
//         return BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: appColor,
//           unselectedItemColor: Colors.white,
//           selectedItemColor: const Color(0xff1B455C),
//           currentIndex: selectIndex,
//           onTap: controller.onItemTapped,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜尋'),
//
//             BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Premium文章'),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: '會員中心')
//           ],
//         );
//       }),
//     );
//   }
// }
