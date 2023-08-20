import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/category.dart';

class LocalStorageProvider extends GetxController {
  LocalStorageProvider._();

  static final LocalStorageProvider _instance = LocalStorageProvider._();

  static LocalStorageProvider get instance => _instance;

  late GetStorage _storage;

  static const String categoryListKey = 'categoryListKey';

  @override
  void onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
  }

  void saveData(String key, dynamic value) {
    _storage.write(key, value);
  }

  dynamic loadData(String key) {
    return _storage.read(key);
  }

  void removeData(String key) {
    _storage.remove(key);
  }

  void saveCategoryList(List<Category> list) {
    _storage.write(categoryListKey, list);
  }

  Future<List<Category>?> loadCategoryList() async {
    if (!_storage.hasData(categoryListKey)) {
      return [];
    }

    return (_storage.read(categoryListKey) as List<dynamic>)
        .map((item) => Category(
              name: item['slug'],
              id: item['slug'],
              title: item['title'],
              isCampaign: item['isCampaign'],
              isSubscribed: item['isSubscribed'],
              isMemberOnly: item['isMemberOnly'],
            ))
        .toList();
  }
}
