import 'package:get/get.dart';
import 'package:readr_app/data/providers/account_api_provider.dart';

class AuthService extends GetxService {
  AuthService._();
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;
  final AccountApiProvider accountApiProvider = Get.find();
  var isLogin = false;

  @override
  void onInit() async {
    super.onInit();
    isLogin = await accountApiProvider.checkIsLogin();
  }
}
