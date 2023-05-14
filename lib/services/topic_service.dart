import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/models/topic_image_item.dart';
import 'package:readr_app/models/topic_item.dart';

abstract class TopicRepos {
  Future<List<Topic>> fetchTopicList(String url,
      {bool isLoadingFirstPage = false});
  Future<List<Topic>> fetchNextPageTopicList();
  Future<List<TopicItem>> fetchTopicItemList(
    String url, {
    bool isLoadingFirstPage = false,
    List<String>? tagIdList,
    List<String>? tagNameList,
  });
  Future<List<TopicItem>> fetchNextPageTopicItemList({
    List<String>? tagIdList,
    List<String>? tagNameList,
  });
  Future<List<TopicImageItem>> fetchPortraitWallList(
      String imageApi, String recordApi);
  Future<List<String>> fethcSlideshowImageList(String topicId);
  bool get isNoMore;
}

class TopicService implements TopicRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
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

    dynamic json;
    if (_page == 1) {
      json = jsonResponse['_endpoints']['topics'];
    } else {
      json = jsonResponse;
    }

    if (json.containsKey("_links") && json["_links"].containsKey("next")) {
      _nextPageUrl =
          '${Environment().config.mirrorMediaDomain}/api/v2/${json["_links"]["next"]["href"]}';
    } else {
      _nextPageUrl = '';
    }

    List<Topic> topics = [];
    var jsonObject = json["_items"];
    for (var item in jsonObject) {
      Topic topic = Topic.fromJson(item);
      topics.add(topic);
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
    List<String>? tagNameList,
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
      _nextPageUrl =
          '${Environment().config.mirrorMediaDomain}/api/v2/membership/v0/${json["_links"]["next"]["href"]}';
    } else {
      _nextPageUrl = '';
      _isNoMore = true;
    }

    List<TopicItem> topicItemList = [];
    var jsonObject = json["_items"];
    for (var item in jsonObject) {
      String? tagId;
      String? tagTitle;
      if (tagIdList != null && item.containsKey("tags")) {
        for (var tag in item["tags"]) {
          if (tagIdList.contains(tag['_id'])) {
            tagId = tag['_id'];
            tagTitle = tag['name'];
            break;
          }
        }
      } else if (tagNameList != null && item.containsKey("tags")) {
        for (var tag in item["tags"]) {
          if (tagNameList.contains(tag['name'])) {
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
    List<String>? tagNameList,
  }) async {
    if (_nextPageUrl != '') {
      _page++;
      return await fetchTopicItemList(_nextPageUrl, tagIdList: tagIdList);
    }

    return [];
  }

  @override
  Future<List<TopicImageItem>> fetchPortraitWallList(
      String imageApi, String recordApi) async {
    dynamic jsonResponse;
    jsonResponse = await _helper.getByCacheAndAutoCache(imageApi,
        maxAge: contentTabCacheDuration);
    var jsonObject = jsonResponse["_items"];
    List<TopicImageItem> portraitWallItemList = [];
    List<String> descriptionList = [];
    for (var object in jsonObject) {
      String imageUrl = '';
      if (object['image'] != null &&
          object['image']['resizedTargets'] != null) {
        imageUrl = object['image']['resizedTargets']['mobile']['url'];
      }
      portraitWallItemList.add(TopicImageItem(
        imageUrl: imageUrl,
        description: object['description'],
      ));
      descriptionList.add(object['description']);
    }

    List<TopicItem> topicItemList = await fetchTopicItemList(
      recordApi,
      isLoadingFirstPage: true,
      tagNameList: descriptionList,
    );
    while (!_isNoMore) {
      topicItemList.addAll(await fetchNextPageTopicItemList(
        tagNameList: descriptionList,
      ));
    }

    for (var topicItem in topicItemList) {
      if (topicItem.tagTitle != null &&
          portraitWallItemList
              .any((element) => element.description == topicItem.tagTitle)) {
        portraitWallItemList
            .firstWhere((element) => element.description == topicItem.tagTitle)
            .record = topicItem.record;
      }
    }

    return portraitWallItemList;
  }

  @override
  Future<List<String>> fethcSlideshowImageList(String topicId) async {
    String imageApi =
        '${Environment().config.mirrorMediaDomain}/api/v2/images?where={"topics":{"\$in":["$topicId"]}}&max_results=25';
    dynamic jsonResponse;
    jsonResponse = await _helper.getByCacheAndAutoCache(imageApi,
        maxAge: contentTabCacheDuration);
    var jsonObject = jsonResponse["_items"];
    List<String> imageUrlList = [];
    for (var object in jsonObject) {
      String imageUrl = '';
      if (object['image'] != null &&
          object['image']['resizedTargets'] != null) {
        imageUrl = object['image']['resizedTargets']['mobile']['url'];
        imageUrlList.add(imageUrl);
      }
    }
    return imageUrlList;
  }
}
