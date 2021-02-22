import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// Custom Implementation of CacheManager
// by extending the BaseCacheManager abstract class
class MMCacheManager extends BaseCacheManager {
  static const key = 'mirrorMediaCache';

  static MMCacheManager _instance;

  // singleton implementation 
  // for the custom cache manager
  factory MMCacheManager() {
    return _instance ??= MMCacheManager._();
  }

  // pass the default setting values to the base class
  // link the custom handler to handle HTTP calls 
  // via the custom cache manager
  MMCacheManager._()
      : super(key,
            maxAgeCacheObject: const Duration(hours: 12),
            maxNrOfCacheObjects: 100);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  Future<bool> isFileExistsAndNotExpired(String url) async {
    final cacheFile = await _instance.getFileFromCache(url);
    return cacheFile != null && cacheFile.validTill.isAfter(DateTime.now());
  }
}