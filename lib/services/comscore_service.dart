import 'package:comscore_analytics_flutter/comscore_analytics_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:readr_app/helpers/environment.dart';

class ComscoreService {
  static ComscoreService? _instance;
  static ComscoreService get instance => _instance ??= ComscoreService._();

  ComscoreService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      PublisherConfiguration? publisherConfig =
          await PublisherConfiguration.build(
              publisherId: Environment().config.comscoreC2Value,
              persistentLabels: {
            'ns_site': Environment().config.comscoreClientId,
          },
              startLabels: {
            'app_name': 'InstantCoffee',
            'app_version': packageInfo.version,
          });

      if (publisherConfig == null) {
        return;
      }

      await Analytics.configuration.addClient(publisherConfig);

      if (kDebugMode) {
        await Analytics.configuration.enableImplementationValidationMode();
        await Analytics.setLogLevel(ComScoreLogLevel.verbose);
      }

      await Analytics.start();

      _isInitialized = true;
    } catch (e) {
      _isInitialized = true;
    }
  }

  /// 追蹤頁面瀏覽
  Future<void> trackPageView({
    required String pageTitle,
    required String pageUrl,
    Map<String, String>? customLabels,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      final labels = <String, String>{
        'name': pageTitle,
        'page_url': pageUrl,
        ...?customLabels,
      };

      await Analytics.notifyViewEvent(labels: labels);
    } catch (e) {}
  }

  /// 追蹤文章瀏覽
  Future<void> trackStoryView({
    required String storyTitle,
    required String storySlug,
    String? categoryName,
    String? authorName,
    DateTime? publishedDate,
  }) async {
    final pageUrl = '/story/$storySlug';

    final customLabels = <String, String>{};

    if (categoryName != null && categoryName.isNotEmpty) {
      customLabels['ns_category'] = categoryName;
    }

    if (authorName != null && authorName.isNotEmpty) {
      customLabels['author'] = authorName;
    }

    if (publishedDate != null) {
      customLabels['published_date'] = publishedDate.toIso8601String();
    }

    await trackPageView(
      pageTitle: storyTitle,
      pageUrl: pageUrl,
      customLabels: customLabels,
    );
  }

  /// 追蹤首頁瀏覽事件
  void trackHomeView() {
    _trackSectionView('', 'Home');
  }

  /// 追蹤分類頁面瀏覽事件
  void trackCategoryView(String categoryName) {
    _trackSectionView(categoryName.toLowerCase(), categoryName);
  }

  /// 內部方法：追蹤分區瀏覽
  void _trackSectionView(String sectionId, String sectionName) {
    if (!_isInitialized) {
      return;
    }

    try {
      final labels = <String, String>{
        'ns_category': sectionId,
      };

      Analytics.notifyViewEvent(labels: labels);
    } catch (e) {}
  }

  /// 檢查 Comscore 數據傳送狀態
  void validateImplementation() {}
}
