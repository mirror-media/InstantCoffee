import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class AppLinkHelper {
  Stream<String> get getStringLinksStream => getLinksStream();

  AppLinkHelper();

  Future<String> getLink() async {
    try {
      return await getInitialLink();
    } on PlatformException {
      return null;
    }
  }

  // it will trigger at the first open
  configAppLink(BuildContext context) async{
    String link = await getLink();
    if(link != null) {
      var linkList = link.split('/');
      // navigate to storyPage
      for(int i=0; i<linkList.length; i++) {
        if(linkList[i] == 'story' && i+1 < linkList.length) {
          _navigateToStoryPage(context, linkList[i+1]);
          break;
        } else if(linkList[i] == 'video' && i+1 < linkList.length) {
          _navigateToStoryPage(context, linkList[i+1], isListeningPage: true);
          break;
        }
      }
    }
  }

  // it will trigger when app is running in the background
  listenAppLink(BuildContext context) async{
    getStringLinksStream.listen((String link) { 
      if(link != null) {
        var linkList = link.split('/');
        // navigate to storyPage
        for(int i=0; i<linkList.length; i++) {
          if(linkList[i] == 'story' && i+1 < linkList.length) {
            _navigateToStoryPage(context, linkList[i+1]);
            break;
          } else if(linkList[i] == 'video' && i+1 < linkList.length) {
            _navigateToStoryPage(context, linkList[i+1], isListeningPage: true);
            break;
          }
        }
      }
    });
  }

  _navigateToStoryPage(BuildContext context, String slug ,{isListeningPage = false}) {
    if(slug != null && slug != '') {
      Navigator.of(context).popUntil((route) => route.isFirst);
      if(isListeningPage) {
        RouteGenerator.navigateToListeningStory(slug);
      } else {
        RouteGenerator.navigateToStory(slug);
      }
    }
  }

  dispose() {}
}