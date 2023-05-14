import 'dart:async';
import 'dart:typed_data';

import 'package:file/memory.dart';
import 'package:file/src/interface/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Custom Implementation of CacheManager
// by extending the BaseCacheManager abstract class
class MockCacheManager extends BaseCacheManager{
  final streamController = StreamController<FileResponse>();
  static const key = 'mockCacheManager';

  static MockCacheManager? _instance;

  // singleton implementation 
  // for the custom cache manager
  factory MockCacheManager() {
    return _instance ??= MockCacheManager._();
  }

  // pass the default setting values to the base class
  // link the custom handler to handle HTTP calls 
  // via the custom cache manager
  MockCacheManager._();

  @override
  Future<void> dispose() async {
    streamController.close();
  }

  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) async{
    return FileInfo(
      MemoryFileSystem.test().file('f'), 
      FileSource.Cache,
      DateTime.now(), 
      'mock_file_url'
    );
  }
  
  @override
  Future<void> emptyCache() async{}
  
  @override
  Stream<FileInfo> getFile(String url, {String? key, Map<String, String>? headers}) {
    return getFileStream(
      url,
      key: key,
      withProgress: false,
    ).where((r) => r is FileInfo).cast<FileInfo>();
  }
  
  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async{
    return null;
  }
  
  @override
  Future<FileInfo?> getFileFromMemory(String key) async{
    return null;
  }
  
  @override
  Stream<FileResponse> getFileStream(String url, {String? key, Map<String, String>? headers, bool? withProgress}) {
    return streamController.stream;
  }
  
  @override
  Future<File> getSingleFile(String url, {String? key, Map<String, String>? headers}) async{
    return MemoryFileSystem.test().file('f');
  }

  @override
  Future<File> putFile(String url, Uint8List fileBytes, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) async{
    return MemoryFileSystem.test().file('f');
  }
  
  @override
  Future<File> putFileStream(String url, Stream<List<int>> source, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) async{
    return MemoryFileSystem.test().file('f');
  }
  
  @override
  Future<void> removeFile(String key) async{}
}