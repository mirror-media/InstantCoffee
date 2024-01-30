import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';

import 'package:readr_app/helpers/app_exception.dart';
import 'package:readr_app/helpers/m_m_cache_manager.dart';
import 'package:readr_app/widgets/logger.dart';

class ApiBaseHelper with Logger {
  Client _client = Client();
  HttpClient httpClient = HttpClient();

  void setClient(Client client) {
    _client = client;

    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  }

  BaseCacheManager? _mMCacheManager;

  void setCacheManager(BaseCacheManager cacheManager) {
    _mMCacheManager = cacheManager;
  }

  /// get cache file by key
  /// the key is url
  Future<dynamic> getByCache(String url) async {
    _mMCacheManager ??= MMCacheManager();

    final cacheFile = await _mMCacheManager!.getFileFromCache(url);
    var file = cacheFile?.file;
    if (file != null && await file.exists()) {
      var mimeStr = lookupMimeType(file.path);
      String res;
      if (mimeStr == 'application/json') {
        res = await file.readAsString();
      } else {
        res = file.path;
      }
      return returnResponse(Response(res, 200));
    }

    return returnResponse(Response("Can not find any cache", 404));
  }

  /// Get the json file from cache first.
  /// If there is no json file from cache,
  /// fetch the json file from get api and save the json file to cache.
  Future<dynamic> getByCacheAndAutoCache(String url,
      {Duration maxAge = const Duration(days: 30),
      Map<String, String> headers = const {
        'Cache-control': 'no-cache'
      }}) async {
    _mMCacheManager ??= MMCacheManager();

    final cacheFile = await _mMCacheManager!.getFileFromCache(url);
    if (cacheFile == null || cacheFile.validTill.isBefore(DateTime.now())) {
      Uri uri = Uri.parse(url);
      dynamic responseJson;
      try {
        final response = await _client.get(uri, headers: headers);
        responseJson = returnResponse(response);
        // save cache file
        _mMCacheManager!.putFile(url, response.bodyBytes,
            maxAge: maxAge, fileExtension: 'json');
      } on SocketException {
        debugLog('No Internet connection');
        throw FetchDataException('No Internet connection');
      } catch (e) {
        debugLog('error: $e');
      }
      debugLog('Api get done.');
      return responseJson;
    }

    var file = cacheFile.file;
    if (await file.exists()) {
      var mimeStr = lookupMimeType(file.path);
      String res;
      if (mimeStr == 'application/json') {
        res = await file.readAsString();
      } else {
        res = file.path;
      }

      return returnResponse(Response(
        res,
        200,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      ));
    }
    return returnResponse(Response("Can not find any cache", 404));
  }

  Future<dynamic> getByUrl(
    String url, {
    Map<String, String> headers = const {'Cache-control': 'no-cache'},
  }) async {
    dynamic responseJson;
    try {
      Uri uri = Uri.parse(url);
      final response = await _client.get(uri, headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      debugLog('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    debugLog('Api get done.');
    return responseJson;
  }

  Future<dynamic> get(String baseUrl, String endpoint) async {
    getByUrl(baseUrl + endpoint);
  }

  Future<dynamic> postByUrl(String url, dynamic body,
      {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      Uri uri = Uri.parse(url);

      final response = await _client.post(uri, headers: headers, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      debugLog('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    debugLog('Api post done.');
    return responseJson;
  }

  Future<dynamic> post(String baseUrl, String endpoint, dynamic body) async {
    postByUrl(baseUrl + endpoint, body);
  }

  Future<dynamic> putByUrl(String url, dynamic body) async {
    dynamic responseJson;
    try {
      Uri uri = Uri.parse(url);
      final response = await _client.put(uri, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      debugLog('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    debugLog('Api put done.');
    return responseJson;
  }

  Future<dynamic> put(String baseUrl, String endpoint, dynamic body) async {
    putByUrl(baseUrl + endpoint, body);
  }

  Future<dynamic> deleteByUrl(String url) async {
    dynamic apiResponse;
    try {
      Uri uri = Uri.parse(url);
      final response = await _client.delete(uri);
      apiResponse = returnResponse(response);
    } on SocketException {
      debugLog('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    debugLog('Api delete done.');
    return apiResponse;
  }

  Future<dynamic> delete(String baseUrl, String endpoint) async {
    deleteByUrl(baseUrl + endpoint);
  }
}

dynamic returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      String utf8Json = utf8.decode(response.bodyBytes);
      var responseJson = json.decode(utf8Json);
      if (responseJson is Map<String, dynamic>) {
        bool hasData = (responseJson.containsKey('_items') &&
                responseJson['_items'].length > 0) ||
            (responseJson.containsKey('items') &&
                responseJson['items'].length > 0) ||
            // properties responded by popular tab content api
            (responseJson.containsKey('report') &&
                responseJson['report'].length > 0) ||
            // properties responded by latest tab content api
            (responseJson.containsKey('latest') &&
                responseJson['latest'] is List) ||
            // properties responded by editor choice api
            (responseJson.containsKey('choices') &&
                responseJson['choices'] is List) ||
            // properties responded by search api
            (responseJson.containsKey('hits') &&
                responseJson['hits'].containsKey('hits')) ||
            // properties responded by member graphql
            (responseJson.containsKey('data') ||
                responseJson.containsKey('tokenState')) ||
            responseJson.containsKey('status') ||
            // error log
            responseJson.containsKey('msg') ||
            // topic list
            responseJson.containsKey('_endpoints') ||
            // Google custom search
            responseJson.containsKey('searchInformation') ||
            // election widget
            responseJson.containsKey('polling') ||
            responseJson.containsKey('posts');

        if (!hasData) {
          throw BadRequestException(response.body.toString());
        }
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
