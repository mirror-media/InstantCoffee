import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Custom Implementation of CacheManager
// by extending the BaseCacheManager abstract class
class MMCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'mirrorMediaCache';

  static MMCacheManager? _instance;

  // singleton implementation 
  // for the custom cache manager
  factory MMCacheManager() {
    return _instance ??= MMCacheManager._();
  }

  // pass the default setting values to the base class
  // link the custom handler to handle HTTP calls 
  // via the custom cache manager
  MMCacheManager._() : super(
    Config(
      key, 
      maxNrOfCacheObjects: 100,
    )
  );

  Future<bool> isFileExistsAndNotExpired(String url) async {
    final cacheFile = await _instance!.getFileFromCache(url);
    return cacheFile != null && cacheFile.validTill.isAfter(DateTime.now());
  }
}