import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';
import 'dart:async';

import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/mMCacheManager.dart';

class ApiBaseHelper {
  /// get cache file by key
  /// the key is url
  Future<dynamic> getByCache(String url) async {
    MMCacheManager mMCacheManager = MMCacheManager();
    final cacheFile = await mMCacheManager.getFileFromCache(url);
    var file = cacheFile?.file;
    if (file != null && await file.exists()) {
      var mimeStr = lookupMimeType(file.path);
      String res;
      if(mimeStr == 'application/json') {
        res = await file.readAsString();
      }
      else {
        res = file.path;
      }
      return returnResponse(http.Response(res, 200));
    }
    
    return returnResponse(http.Response(null, 404));
  }

  /// Get the json file from cache first.
  /// If there is no json file from cache, 
  /// fetch the json file from get api and save the json file to cache.
  Future<dynamic> getByCacheAndAutoCache(
    String url, 
    {
      Duration maxAge = const Duration(days: 30),
      Map<String,String> headers = const {'Cache-control': 'no-cache'},
    }
  ) async {
    //print('Get cache, url $url');
    MMCacheManager mMCacheManager = MMCacheManager();
    final cacheFile = await mMCacheManager.getFileFromCache(url);
    if ( cacheFile == null ||
      cacheFile != null && cacheFile.validTill.isBefore(DateTime.now())
    ) {
      //print('Call Api Get, url $url');
      var responseJson;
      try {
        final response =
            await http.get(url, headers: headers);
        responseJson = returnResponse(response);
        // save cache file
        mMCacheManager.putFile(url, response.bodyBytes, maxAge: maxAge, fileExtension: 'json');
      } on SocketException {
        print('No Internet connection');
        throw FetchDataException('No Internet connection');
      } catch(e) {
        print('error: $e');
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
      
      return returnResponse(http.Response(res, 200));
    }
    return returnResponse(http.Response(null, 404));
  }

  Future<dynamic> getByUrl(
    String url,
    {
      Map<String,String> headers = const {'Cache-control': 'no-cache'},
    }
  ) async {
    //print('Call Api Get, url $url');
    var responseJson;
    try {
      final response =
          await http.get(url, headers: headers);
      responseJson = returnResponse(response);
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

  Future<dynamic> postByUrl(String url, dynamic body, {Map<String, String> headers}) async {
    //print('Call Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(url, headers: headers, body: body);
      responseJson = returnResponse(response);
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
    //print('Call Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(url, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('Api put done.');
    return responseJson;
  }

  Future<dynamic> put(String baseUrl, String endpoint, dynamic body) async {
    putByUrl(baseUrl + endpoint, body);
  }

  Future<dynamic> deleteByUrl(String url) async {
    //print('Call Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(url);
      apiResponse = returnResponse(response);
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

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      String utf8Json = utf8.decode(response.bodyBytes);
      var responseJson = json.decode(utf8Json);

      bool hasData = (responseJson.containsKey('_items') && responseJson['_items'].length > 0) || 
        (responseJson.containsKey('items') && responseJson['items'].length > 0) || 
        // properties responded by popular tab content api
        (responseJson.containsKey('report') && responseJson['report'].length > 0) || 
        // properties responded by editor choice api
        (responseJson.containsKey('choices') && responseJson['choices'].length > 0) || 
        // properties responded by search api
        (responseJson.containsKey('hits') && responseJson['hits'].containsKey('hits')) ||
        // properties responded by member graphql
        (responseJson.containsKey('data') || responseJson.containsKey('tokenState'));
      if(!hasData) {
        throw BadRequestException(response.body.toString());
      }
      
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
