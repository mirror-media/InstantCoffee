import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';
import 'dart:async';

import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/mMCacheManager.dart';

class ApiBaseHelper {
  Future<dynamic> getByCache(String url, {Duration maxAge = const Duration(days: 30),}) async {
    print('Get cache, url $url');
    MMCacheManager mMCacheManager = MMCacheManager();
    final cacheFile = await mMCacheManager.getFileFromCache(url);
    if ( cacheFile == null ||
      cacheFile != null && cacheFile.validTill.isBefore(DateTime.now())
    ) {
      print('Call Api Get, url $url');
      var responseJson;
      try {
        final response =
            await http.get(url, headers: {'Cache-control': 'no-cache'});
        responseJson = _returnResponse(response);
        // save cache file
        mMCacheManager.putFile(url, response.bodyBytes, maxAge: maxAge, fileExtension: 'json');
      } on SocketException {
        print('No Internet connection');
        throw FetchDataException('No Internet connection');
      }
      print('Api get done.');
      return responseJson;
    }

    var file = cacheFile.file;
    if (file != null && await file.exists()) {
      var mimeStr = lookupMimeType(file.path);
      String res;
      if(mimeStr == 'application/json') {
        res = await file.readAsString();
      }
      else {
        res = file.path;
      }
      
      return _returnResponse(http.Response(res, 200));
    }
    return _returnResponse(http.Response(null, 404));
  }

  Future<dynamic> getByUrl(String url) async {
    print('Call Api Get, url $url');
    var responseJson;
    try {
      final response =
          await http.get(url, headers: {'Cache-control': 'no-cache'});
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('Api get done.');
    return responseJson;
  }

  Future<dynamic> get(String baseUrl, String endpoint) async {
    getByUrl(baseUrl + endpoint);
  }

  Future<dynamic> postByUrl(String url, dynamic body) async {
    print('Call Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('Api post done.');
    return responseJson;
  }

  Future<dynamic> post(String baseUrl, String endpoint, dynamic body) async {
    postByUrl(baseUrl + endpoint, body);
  }

  Future<dynamic> putByUrl(String url, dynamic body) async {
    print('Call Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('Api put done.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> put(String baseUrl, String endpoint, dynamic body) async {
    putByUrl(baseUrl + endpoint, body);
  }

  Future<dynamic> deleteByUrl(String url) async {
    print('Call Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(url);
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('Api delete done.');
    return apiResponse;
  }

  Future<dynamic> delete(String baseUrl, String endpoint) async {
    deleteByUrl(baseUrl + endpoint);
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
