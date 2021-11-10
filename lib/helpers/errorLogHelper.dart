import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/environment.dart';

class ErrorLogHelper {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<bool> record(
    String eventName,
    Map eventParametersMap,
    String errorMessage,
  ) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    Map bodyString = {
      'eventName': eventName,
      'eventParameters': eventParametersMap,
      'firebaseId': _auth.currentUser?.uid,
      'user': _auth.currentUser?.email,
      'OS': Platform.operatingSystem,
      'appVersion': _packageInfo.version.toLowerCase(),
      'errorMessage': errorMessage,
    };

    final jsonResponse = await _apiBaseHelper.postByUrl(
      '${Environment().config.errorLogApi}?logName=${Environment().config.errorLogName}', 
      jsonEncode(bodyString),
      headers: {"Content-Type": "application/json"},
    );

    return jsonResponse.containsKey('msg') && jsonResponse['msg'] == 'Received.';
  }
 }