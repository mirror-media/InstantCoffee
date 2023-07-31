import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../models/member_subscription_type.dart';
import '../../services/member_service.dart';

class AccountApiProvider extends GetConnect {
  AccountApiProvider._();

  static final AccountApiProvider _instance = AccountApiProvider._();

  static AccountApiProvider get instance => _instance;
  final MemberRepos memberRepos = MemberService();

  Future<bool> checkIsLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return false;
    } else {
      MemberIdAndSubscriptionType memberIdAndSubscriptionType =
          await memberRepos.checkSubscriptionType(auth.currentUser!);

      if (memberIdAndSubscriptionType.state == MemberStateType.active) {
        return true;
      }
    }
    return false;
  }
}
