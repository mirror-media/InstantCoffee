import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/environment.dart';

class ErrorLogHelper {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<bool> record(
    String eventName,
    Map? eventParametersMap,
    String errorMessage,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map bodyString = {
      'eventName': eventName,
      'eventParameters': eventParametersMap,
      'firebaseId': auth.currentUser?.uid,
      'user': auth.currentUser?.email,
      'OS': Platform.operatingSystem,
      'appVersion': packageInfo.version.toLowerCase(),
      'errorMessage': errorMessage,
    };

    final jsonResponse = await _apiBaseHelper.postByUrl(
      '${Environment().config.errorLogApi}?logName=${Environment().config.errorLogName}',
      jsonEncode(bodyString),
      headers: {"Content-Type": "application/json"},
    );

    return jsonResponse.containsKey('msg') &&
        jsonResponse['msg'] == 'Received.';
  }
}
