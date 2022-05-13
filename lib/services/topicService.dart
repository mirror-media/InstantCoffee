import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/topic.dart';

abstract class TopicRepos {
  Future<List<Topic>> fetchTopicList(String url,
      {bool isLoadingFirstPage = false});
  Future<List<Topic>> fetchNextPageTopicList();
}

class TopicService implements TopicRepos {
  ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;
  String _nextPageUrl = '';

  @override
  Future<List<Topic>> fetchTopicList(String url,
      {bool isLoadingFirstPage = false}) async {
    if (isLoadingFirstPage) {
      _page = 1;
      _nextPageUrl = '';
    }

    dynamic jsonResponse;
    if (_page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url,
          maxAge: contentTabCacheDuration);
    } else {
      jsonResponse = await _helper.getByUrl(url);
    }

    var json;
    if (_page == 1) {
      json = jsonResponse['_endpoints']['topics'];
    } else {
      json = jsonResponse;
    }

    if (json.containsKey("_links") && json["_links"].containsKey("next")) {
      _nextPageUrl = Environment().config.mirrorMediaDomain +
          '/api/v2/' +
          json["_links"]["next"]["href"];
    } else {
      _nextPageUrl = '';
    }

    List<Topic> topics = [];
    var jsonObject = json["_items"];
    for (var item in jsonObject) {
      topics.add(Topic.fromJson(item));
    }

    topics.sort((a, b) {
      if (a.isFeatured && b.isFeatured) {
        return a.sortOrder.compareTo(b.sortOrder);
      } else if (a.isFeatured) {
        return -1;
      } else {
        return 1;
      }
    });

    return topics;
  }

  @override
  Future<List<Topic>> fetchNextPageTopicList() async {
    if (_nextPageUrl != '') {
      _page++;
      return await fetchTopicList(_nextPageUrl);
    }

    return [];
  }
}
