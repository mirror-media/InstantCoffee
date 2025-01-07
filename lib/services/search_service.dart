import 'package:get/get.dart';

class SearchService extends GetxService{
// 私有構造函數
  SearchService._privateConstructor();

  // 單例實例
  static final SearchService _instance = SearchService._privateConstructor();

  // 提供外部訪問的單例方法
  static SearchService get instance => _instance;

  @override
  void onInit() {
    super.onInit();


  }
}