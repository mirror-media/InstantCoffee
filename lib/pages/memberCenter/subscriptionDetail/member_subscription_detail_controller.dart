import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/models/member_subscription_type.dart';

class MemberSubscriptionDetailController extends GetxController {
  final AuthInfoProvider authInfoProvider = Get.find();
  final Rxn<SubscriptionType> rxnSubscriptionType = Rxn();

  MemberSubscriptionDetailController(SubscriptionType type) {
    rxnSubscriptionType.value = type;
  }

  @override
  void onInit() {}
}
