import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCacheService extends GetxService {
  late SharedPreferences _prefs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  /// 初始化（在 app 啟動時 Get.put(AppCacheService())）
  Future<AppCacheService> init() async {
    return this;
  }

  /// 存 String
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// 取 String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// 存 bool
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// 取 bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// 存 int
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// 取 int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// 刪除某個 key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// 清空所有
  Future<void> clear() async {
    await _prefs.clear();
  }
}
