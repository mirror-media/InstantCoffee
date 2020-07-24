import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:readr_app/helpers/appException.dart';

class ApiBaseHelper {
  Future<dynamic> getByUrl(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> get(String baseUrl, String endpoint) async {
    getByUrl(baseUrl+endpoint);
  }

  Future<dynamic> postByUrl(String url, dynamic body) async {
    print('Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> post(String baseUrl, String endpoint, dynamic body) async {
    postByUrl(baseUrl+endpoint, body);
  }

  Future<dynamic> putByUrl(String url, dynamic body) async {
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> put(String baseUrl, String endpoint, dynamic body) async {
    putByUrl(baseUrl+endpoint, body);
  }

  Future<dynamic> deleteByUrl(String url) async {
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(url);
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }

  Future<dynamic> delete(String baseUrl, String endpoint) async {
    deleteByUrl(baseUrl+endpoint);
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
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
