import 'dart:io';

import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberBloc.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/mirrorApp.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/magazineBrowser.dart';
import 'package:readr_app/pages/magazinePage.dart';
import 'package:readr_app/pages/memberPage.dart';
import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/pages/searchPage.dart';
import 'package:readr_app/pages/storyPage.dart';
import 'package:readr_app/widgets/deleteMemberWidget.dart';
import 'package:readr_app/widgets/editMemberProfile.dart';
import 'package:readr_app/widgets/editMemberContactInfo.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteGenerator {
  static const String root = '/';
  static const String search = '/search';
  static const String member = '/member';
  static const String editMemberProfile = '/editMemberProfile';
  static const String editMemberContactInfo = '/editMemberContactInfo';
  static const String deleteMember = '/deleteMember';
  static const String notificationSettings = '/notificationSettings';
  static const String story = '/story';
  static const String magazine = '/magazine';
  static const String magazineBrowser = '/magazineBrowser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MirrorApp()
        );
      case search:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SearchPage(),
          fullscreenDialog: true,
        );
      case member:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MemberPage(
            routeName: args['routeName']??member,
            routeArguments: args['routeArguments'],
            isEmailLoginAuth: args['isEmailLoginAuth']??false,
            emailLink: args['emailLink'],
          ),
          fullscreenDialog: true,
        );
      case editMemberProfile:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberProfile(
            member: args['member'],
            memberBloc: args['memberBloc'],
          ),
          fullscreenDialog: true,
        );
      case editMemberContactInfo:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberContactInfo(
            member: args['member'],
            memberBloc: args['memberBloc'],
          ),
          fullscreenDialog: true,
        );
      case deleteMember:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DeleteMemberWidget(
            member: args['member'],
          ),
          fullscreenDialog: true,
        );
      case notificationSettings:
        Object args = settings.arguments;
        // Validation of correct data type
        if (args is OnBoardingBloc) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NotificationSettingsPage(
              onBoardingBloc: args,
            ),
            fullscreenDialog: true,
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case story:
        Map args = settings.arguments;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
            builder: (context) => StoryPage(
              slug: args['slug'],
              isListeningWidget: args['isListeningWidget']??false,
            )
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case magazine:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazinePage()
        );
      case magazineBrowser:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazineBrowser(
            magazine: args['magazine'],
          )
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
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      }
    );
  }

  static void navigateToSearch(BuildContext context) {
    Navigator.of(context).pushNamed(search);
  }

  static void navigateToMember(
    BuildContext context, 
    {
      String routeName = member,
      Object routeArguments,
      bool isEmailLoginAuth = false,
      String emailLink,
    }
  ) {
    Navigator.of(context).pushNamed(
      member,
      arguments: {
        'routeName': routeName,
        'routeArguments': routeArguments,
        'isEmailLoginAuth': isEmailLoginAuth,
        'emailLink': emailLink,
      },
    );
  }

  static void navigateToEditMemberProfile(
    BuildContext context, 
    Member member,
    MemberBloc memberBloc,
  ) {
    Navigator.of(context).pushNamed(
      editMemberProfile,
      arguments: {
        'member': member,
        'memberBloc': memberBloc,
      },
    );
  }

  static void navigateToEditMemberContactInfo(
    BuildContext context, 
    Member member, 
    MemberBloc memberBloc,
  ) {
    Navigator.of(context).pushNamed(
      editMemberContactInfo,
      arguments: {
        'member': member,
        'memberBloc': memberBloc,
      },
    );
  }

  static void navigateToDeleteMember(
    BuildContext context, 
    Member member, 
  ) {
    Navigator.of(context).pushNamed(
      deleteMember,
      arguments: {
        'member': member,
      },
    );
  }

  static void navigateToNotificationSettings(BuildContext context, OnBoardingBloc onBoardingBloc) {
    Navigator.of(context).pushNamed(
      notificationSettings,
      arguments: onBoardingBloc,
    );
  }

  static void navigateToStory(BuildContext context, String slug, {bool isListeningWidget = false}) {
    Navigator.of(context).pushNamed(
      story,
      arguments: {
        'slug': slug,
        'isListeningWidget': isListeningWidget,
      },
    );
  }

  static void navigateToMagazine(BuildContext context) {
    Navigator.of(context).pushNamed(
      magazine,
    );
  }

  static void navigateToMagazineBrowser(
    BuildContext context,
    Magazine magazine
  ) async{
    // https://github.com/flutter/flutter/issues/48245
    // There is a issue when opening pdf file in webview on android, 
    // so change to launch URL on android.
    if(Platform.isAndroid) {
      if (await canLaunch(magazine.pdfUrl)) {
        await launch(magazine.pdfUrl);
      } else {
        throw 'Could not launch $magazine.pdfUrl';
      }
    } else {
      Navigator.of(context).pushNamed(
        magazineBrowser,
        arguments: {
          'magazine': magazine,
        },
      );
    }
  }

  static void printRouteSettings(BuildContext context) {
    var route = ModalRoute.of(context);
    if(route!=null){
      print('route is current: ${route.isCurrent}');
      print('route name: ${route.settings.name}');
      print('route arg: ${route.settings.arguments.toString()}');
    }
  }
}