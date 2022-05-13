import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/models/topicItem.dart';

abstract class TopicRepos {
  Future<List<Topic>> fetchTopicList(String url,
      {bool isLoadingFirstPage = false});
  Future<List<Topic>> fetchNextPageTopicList();
  Future<List<TopicItem>> fetchTopicItemList(
    String url, {
    bool isLoadingFirstPage = false,
    List<String>? tagIdList,
  });
  Future<List<TopicItem>> fetchNextPageTopicItemList({
    List<String>? tagIdList,
  });
  bool get isNoMore;
}

class TopicService implements TopicRepos {
  ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;
  String _nextPageUrl = '';
  bool _isNoMore = false;

  @override
  bool get isNoMore => _isNoMore;

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

  @override
  Future<List<TopicItem>> fetchTopicItemList(
    String url, {
    bool isLoadingFirstPage = false,
    List<String>? tagIdList,
  }) async {
    if (isLoadingFirstPage) {
      _page = 1;
      _nextPageUrl = '';
      _isNoMore = false;
    }

    dynamic jsonResponse;
    if (_page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url,
          maxAge: contentTabCacheDuration);
    } else {
      jsonResponse = await _helper.getByUrl(url);
    }

    var json = jsonResponse['data'];

    if (json.containsKey("_links") && json["_links"].containsKey("next")) {
      _nextPageUrl = Environment().config.mirrorMediaDomain +
          '/api/v2/membership/v0/' +
          json["_links"]["next"]["href"];
    } else {
      _nextPageUrl = '';
      _isNoMore = true;
    }

    List<TopicItem> topicItemList = [];
    var jsonObject = json["_items"];
    for (var item in jsonObject) {
      String? tagId;
      String? tagTitle;
      if (tagIdList != null && json.containsKey("tags")) {
        for (var tag in json["tags"]) {
          if (tagIdList.contains(tag['_id'])) {
            tagId = tag['_id'];
            tagTitle = tag['name'];
            break;
          }
        }
      }
      topicItemList.add(TopicItem(
        record: Record.fromJson(item),
        isFeatured: item['isFeatured'],
        tagId: tagId,
        tagTitle: tagTitle,
      ));
    }

    return topicItemList;
  }

  @override
  Future<List<TopicItem>> fetchNextPageTopicItemList({
    List<String>? tagIdList,
  }) async {
    if (_nextPageUrl != '') {
      _page++;
      return await fetchTopicItemList(_nextPageUrl, tagIdList: tagIdList);
    }

    return [];
  }
}
