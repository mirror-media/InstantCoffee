import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:readr_app/models/miso_search_response.dart';

class MisoSearchService {
  static const String apiKey = 'IHtn9b9tfPsO1EQpGV74OMf2syhELb6XVZe8u9FT';

  final String anonymousId;
  final String? userId;
  final http.Client _client;

  MisoSearchService({
    required this.anonymousId,
    this.userId,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<MisoSearchResponse> search(String q) async {
    final body = {
      'anonymous_id': anonymousId,
      if (userId != null) 'user_id': userId,
      'q': q,
      'fq': 'product_id:/(mirrormedia_story_).+/',
      'facets': ['custom_attributes.article:section'],
      'snippet_max_chars': 60,
      'fl': [
        'product_id',
        'cover_image',
        'url',
        'published_at',
        'title',
        'authors',
        'custom_attributes.*',
        'comments',
        'comment_count',
        'product_id',
      ],
      'exclude': [
        'product_id_1',
        'product_id_2',
        'product_id_3',
      ],
      'rows': 20,
      'order_by': 'relevance',
      'answer': true,
      'source_fl': [
        'cover_image',
        'url',
        'created_at',
        'updated_at',
        'published_at',
        'title',
        'authors',
        'custom_attributes.*',
        'comments',
        'comment_count',
        'product_id',
      ],
      'cite_link': 1,
      'cite_start': '[',
      'cite_end': ']',
    };

    final uri = Uri.parse('https://api.askmiso.com/v1/ask/search')
        .replace(queryParameters: {'api_key': apiKey});

    final resp = await _client.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(resp.body);
    }

    return MisoSearchResponse.fromJson(
      jsonDecode(resp.body) as Map<String, dynamic>,
    );
  }
}