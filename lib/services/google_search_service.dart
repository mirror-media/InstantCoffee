import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/vertex_search_article.dart';

class GoogleSearchService extends GetxService {
  GoogleSearchService._();

  static final GoogleSearchService _instance = GoogleSearchService._();

  static GoogleSearchService get instance => _instance;

  final String endpoint = Environment().config.vertexSearchApi;

  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<List<VertexSearchArticle>> searchDiscoveryEngine(
      {required String query, int? skip = 1, int? take = 10}) async {
    if (skip! < 1 || skip > 100 || take! < 1) {
      return [];
    }

    final String url = '$endpoint?query=$query&skip=$skip&take=$take';

    try {
      final response = await apiBaseHelper.getByUrl(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ) as Map<String, dynamic>;

      if (response.containsKey('success') && response['success'] == true) {
        final dataList = response['data'] as List<dynamic>;
        return dataList.map((e) => VertexSearchArticle.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
