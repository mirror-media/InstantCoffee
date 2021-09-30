import "dart:convert" show utf8;

import 'package:readr_app/env.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/models/appVersion.dart';

class AppVersionService {
  Future<List<AppVersion>> fetchMajorVersion() async {
    Uri uri = Uri.parse(env.baseConfig.appVersionApi);
    final jsonResponse = await http.get(
      uri, 
      headers: const {
        'Cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=utf-8'
      }
    );
    
    var jsonBody = utf8.decode(jsonResponse.bodyBytes);
    List<AppVersion> appVersionList = AppVersion.parseAppVersion(jsonBody);
    
    return appVersionList;
  }
}
