import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';

class MemberWidgetController extends GetxController {
  final AuthInfoProvider authInfoProvider = Get.find();
  final RxBool rxIsLoading=false.obs;
}
