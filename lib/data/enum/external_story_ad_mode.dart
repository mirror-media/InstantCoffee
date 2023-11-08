/// External Story 取得的廣告來源
/// 目前只有兩個 後續可能因為邏輯新增？
enum ExternalStoryAdMode {
  news,
  life,
  other,
}

extension ExternalStoryAdModeExtension on ExternalStoryAdMode {
  String get key {
    switch (this) {
      case ExternalStoryAdMode.news:
        return 'news';

      case ExternalStoryAdMode.life:
        return 'life';
      case ExternalStoryAdMode.other:
        return 'other';
    }
  }

  String get displayText {
    switch (this) {
      case ExternalStoryAdMode.news:
        return '時事';
      case ExternalStoryAdMode.life:
        return '生活';
      case ExternalStoryAdMode.other:
        return '其他';
    }
  }
}
