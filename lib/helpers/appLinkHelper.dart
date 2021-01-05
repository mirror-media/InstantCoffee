import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:uni_links/uni_links.dart';

class AppLinkHelper {
  AppLinkHelper();

  Future<String> getLink() async {
    try {
      return await getInitialLink();
    } on PlatformException {
      return null;
    }
  }

  Stream<String> get getStringLinksStream => getLinksStream();

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

  _navigateToStoryPage(BuildContext context, String slug ,{isListeningPage = false}) {
    if(slug != null && slug != '') {
      RouteGenerator.navigateToStory(context, slug, isListeningWidget: isListeningPage);
    }
  }

  dispose() {}
}