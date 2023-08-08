import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/initial_app.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/pages/article_info_page/article_info_page_controller.dart';
import 'package:readr_app/pages/emailLogin/email_login_page.dart';
import 'package:readr_app/pages/emailRegistered/email_registered_page.dart';
import 'package:readr_app/pages/emailVerification/email_verification_page.dart';
import 'package:readr_app/pages/login/login_page.dart';
import 'package:readr_app/pages/magazine_browser.dart';
import 'package:readr_app/pages/magazine/magazine_page.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/delete_member_page.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/newebpay_change_plan_page.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/subscription_select_page.dart';
import 'package:readr_app/pages/settingPage/notification_settings_page.dart';
import 'package:readr_app/pages/passwordReset/password_reset_page.dart';
import 'package:readr_app/pages/passwordResetEmail/password_reset_email_page.dart';
import 'package:readr_app/pages/passwordResetPrompt/password_reset_prompt_page.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_page.dart';
import 'package:readr_app/pages/search/search_page.dart';
import 'package:readr_app/pages/settingPage/premium_setting_page.dart';
import 'package:readr_app/pages/article_info_page/article_info_page.dart';
import 'package:readr_app/pages/storyPage/external/external_story_page.dart';
import 'package:readr_app/pages/storyPage/listening/listening_story_page.dart';
import 'package:readr_app/pages/storyPage/news/story_page.dart';

import 'package:readr_app/pages/memberCenter/editMemberProfile/edit_member_profile_page.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/edit_member_contact_info_page.dart';
import 'package:readr_app/pages/tag/tag_page.dart';
import 'package:readr_app/pages/topic_page/topic_page.dart';
import 'package:readr_app/widgets/image_viewer_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/topic/topic_model.dart';
import '../pages/article_info_page/article_info_page_binding.dart';
import '../pages/topic_page/topic_page_binding.dart';

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static const String root = '/';
  static const String search = '/search';
  static const String login = '/login';
  static const String emailRegistered = '/emailRegistered';
  static const String emailLogin = '/emailLogin';
  static const String passwordResetPrompt = '/passwordResetPrompt';
  static const String passwordResetEmail = '/passwordResetEmail';
  static const String passwordReset = '/passwordReset';
  static const String passwordUpdate = '/passwordUpdate';
  static const String editMemberProfile = '/editMemberProfile';
  static const String editMemberContactInfo = '/editMemberContactInfo';
  static const String deleteMember = '/deleteMember';
  static const String emailVerification = '/emailVerification';
  static const String notificationSettings = '/notificationSettings';
  static const String premiumSettings = '/premiumSettings';
  static const String story = '/story';
  static const String externalStory = '/externalStory';
  static const String listeningStory = '/listeningStory';
  static const String magazine = '/magazine';
  static const String magazineBrowser = '/magazineBrowser';
  static const String subscriptionSelect = '/subscriptionSelect';
  static const String newebpayChangePlan = '/newebpayChangePlan';
  static const String tagPage = '/tag';
  static const String imageViewer = '/imageViewer';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
            settings: settings, builder: (_) => InitialApp());
      case search:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SearchPage(),
          fullscreenDialog: true,
        );
      case login:
        String? routeName;
        Map? routeArguments;

        if (settings.arguments != null) {
          Map args = settings.arguments as Map;
          routeName = args['routeName'];
          routeArguments = args['routeArguments'];
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => LoginPage(
            routeName: routeName,
            routeArguments: routeArguments,
          ),
          fullscreenDialog: true,
        );
      case emailRegistered:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailRegisteredPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case emailLogin:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailLoginPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordResetPrompt:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PasswordResetPromptPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordResetEmail:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PasswordResetEmailPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordReset:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PasswordResetPage(
            code: args['code'],
          ),
          fullscreenDialog: true,
        );
      case passwordUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PasswordUpdatePage(),
          fullscreenDialog: true,
        );
      case editMemberProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberProfilePage(),
          fullscreenDialog: true,
        );
      case editMemberContactInfo:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberContactInfoPage(),
          fullscreenDialog: true,
        );
      case deleteMember:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DeleteMemberPage(
            israfelId: args['israfelId'],
            subscriptionType: args['subscriptionType'],
          ),
          fullscreenDialog: true,
        );
      case emailVerification:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailVerificationPage(),
          fullscreenDialog: true,
        );
      case notificationSettings:
        Object args = settings.arguments!;
        // Validation of correct data type
        if (args is OnBoardingBloc) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider.value(
              value: args,
              child: NotificationSettingsPage(),
            ),
            fullscreenDialog: true,
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case premiumSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PremiumSettingPage(),
          fullscreenDialog: true,
        );
      case story:
        Map args = settings.arguments as Map;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
            builder: (context) => StoryPage(
              slug: args['slug'],
              isMemberCheck: args['isMemberCheck'],
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case externalStory:
        Map args = settings.arguments as Map;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
              builder: (context) => ExternalStoryPage(
                    slug: args['slug'],
                    isPremiumMode: args['isPremiumMode'],
                  ));
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case listeningStory:
        Map args = settings.arguments as Map;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
              builder: (context) => ListeningStoryPage(
                    slug: args['slug'],
                  ));
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case magazine:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => MagazinePage(
                  subscriptionType: args['subscriptionType'],
                ));
      case magazineBrowser:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => MagazineBrowser(
                  magazine: args['magazine'],
                ));
      case subscriptionSelect:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SubscriptionSelectPage(
            storySlug: args['storySlug'],
          ),
        );
      case newebpayChangePlan:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => NewebpayChangePlanPage(),
        );
      case tagPage:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => TagPage(
            tag: args['tag'],
          ),
        );
      case imageViewer:
        Map args = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ImageViewerWidget(
            args['imageUrlList'],
            openIndex: args['openIndex'],
          ),
          fullscreenDialog: true,
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: const Center(
              child: Text('ERROR'),
            ),
          );
        });
  }

  static void navigateToSearch() {
    navigatorKey.currentState!.pushNamed(search);
  }

  static void navigateToLogin({
    String? routeName,
    Map? routeArguments,
  }) {
    navigatorKey.currentState!.pushNamed(
      login,
      arguments: {
        'routeName': routeName,
        'routeArguments': routeArguments,
      },
    );
  }

  static Future<void> navigateToEmailRegistered({
    required String email,
  }) async {
    await navigatorKey.currentState!.pushNamed(
      emailRegistered,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToEmailLogin({
    required String email,
  }) async {
    await navigatorKey.currentState!.pushNamed(
      emailLogin,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetPrompt({
    required String email,
  }) async {
    await navigatorKey.currentState!.pushNamed(
      passwordResetPrompt,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetEmail({
    required String email,
  }) async {
    await navigatorKey.currentState!.pushNamed(
      passwordResetEmail,
      arguments: {
        'email': email,
      },
    );
  }

  static void navigateToPasswordReset({
    required String code,
  }) {
    navigatorKey.currentState!.pushNamed(
      passwordReset,
      arguments: {
        'code': code,
      },
    );
  }

  static void navigateToPasswordUpdate() {
    navigatorKey.currentState!.pushNamed(passwordUpdate);
  }

  static void navigateToEditMemberProfile() {
    navigatorKey.currentState!.pushNamed(editMemberProfile);
  }

  static void navigateToEditMemberContactInfo() {
    navigatorKey.currentState!.pushNamed(editMemberContactInfo);
  }

  static void navigateToDeleteMember(
      String israfelId, SubscriptionType subscriptionType) {
    navigatorKey.currentState!.pushNamed(
      deleteMember,
      arguments: {
        'israfelId': israfelId,
        'subscriptionType': subscriptionType,
      },
    );
  }

  static void navigateToEmailVerification() {
    navigatorKey.currentState!.pushNamed(
      emailVerification,
    );
  }

  static void navigateToNotificationSettings(OnBoardingBloc onBoardingBloc) {
    navigatorKey.currentState!.pushNamed(
      notificationSettings,
      arguments: onBoardingBloc,
    );
  }

  static void navigateToPremiumSettingPage() {
    navigatorKey.currentState!.pushNamed(premiumSettings);
  }

  static void navigateToStory(String slug,
      {bool isMemberCheck = true, String? url}) {
    if (url != null) {
      launchUrlString(url);
    } else {
      Get.delete<ArticleInfoPagePageBinding>();
      Get.delete<ArticleInfoPageController>();
      Get.offAll(
        () => const ArticleInfoPage(),
        predicate: (router) => router.settings.name != '/ArticleInfoPage',
        binding: ArticleInfoPagePageBinding(),
        arguments: {
          'slug': slug,
          'isMemberCheck': isMemberCheck,
        },
      );
    }
  }

  static void navigateToExternalStory(String slug,
      {bool isPremiumMode = false}) {
    navigatorKey.currentState!.pushNamed(
      externalStory,
      arguments: {
        'slug': slug,
        'isPremiumMode': isPremiumMode,
      },
    );
  }

  static void navigateToListeningStory(String slug) {
    navigatorKey.currentState!.pushNamed(
      listeningStory,
      arguments: {'slug': slug},
    );
  }

  static void navigateToMagazine(
    SubscriptionType subscriptionType,
  ) {
    navigatorKey.currentState!.pushNamed(
      magazine,
      arguments: {'subscriptionType': subscriptionType},
    );
  }

  static void navigateToMagazineBrowser(Magazine magazine) async {
    // https://github.com/flutter/flutter/issues/48245
    // There is a issue when opening pdf file in webview on android,
    // so change to launch URL on android.
    String url =
        magazine.type == 'weekly' ? magazine.onlineReadingUrl : magazine.pdfUrl;

    if (url == '') {
      Fluttertoast.showToast(
          msg: '下載失敗，請再試一次',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (magazine.type == 'weekly') {
      InAppBrowser browser = InAppBrowser();
      browser.openUrlRequest(
        urlRequest: URLRequest(
          url: Uri.parse(url),
        ),
        options: InAppBrowserClassOptions(
          crossPlatform: InAppBrowserOptions(
            hideUrlBar: true,
            toolbarTopBackgroundColor: appColor,
            hideToolbarTop: Platform.isAndroid,
          ),
          ios: IOSInAppBrowserOptions(
            hideToolbarBottom: true,
            closeButtonColor: Colors.white,
          ),
          android: AndroidInAppBrowserOptions(
            closeOnCannotGoBack: false,
            shouldCloseOnBackButtonPressed: true,
          ),
        ),
      );
    } else {
      if (Platform.isAndroid) {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        navigatorKey.currentState!.pushNamed(
          magazineBrowser,
          arguments: {
            'magazine': magazine,
          },
        );
      }
    }
  }

  static void navigateToSubscriptionSelect({
    bool usePushReplacement = false,
    bool isNewebpay = false,
    String? storySlug,
  }) {
    if (usePushReplacement) {
      navigatorKey.currentState!.pushReplacementNamed(
        subscriptionSelect,
        arguments: {'storySlug': storySlug},
      );
    } else if (isNewebpay) {
      navigatorKey.currentState!.pushNamed(
        newebpayChangePlan,
      );
    } else {
      navigatorKey.currentState!.pushNamed(
        subscriptionSelect,
        arguments: {'storySlug': storySlug},
      );
    }
  }

  static void navigateToTagPage(Tag tag) {
    navigatorKey.currentState!.pushNamed(
      tagPage,
      arguments: {'tag': tag},
    );
  }

  static void navigateToImageViewer(List<String> imageUrlList,
      {int openIndex = 0}) {
    navigatorKey.currentState!.pushNamed(
      imageViewer,
      arguments: {
        'imageUrlList': imageUrlList,
        'openIndex': openIndex,
      },
    );
  }

  static void printRouteSettings() {
    var route = ModalRoute.of(navigatorKey.currentContext!);
    if (route != null) {
      debugPrint('route is current: ${route.isCurrent}');
      debugPrint('route name: ${route.settings.name}');
      debugPrint('route arg: ${route.settings.arguments.toString()}');
    }
  }

  /// 目前Router管理很亂，需要全部換成一個方式才能整合，目前先用這方式 下下策
  static void routerToTopicPage({required TopicModel topic}) {
    Get.to(const TopicPage(),
        binding: TopicPageBinding(), arguments: {'topic': topic});
  }
}
