import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/account_status.dart';

import '../../../helpers/data_constants.dart';

class MemberRegistrationWidget extends StatelessWidget {
  final AccountStatus accountStatus;
  final Function(AccountStatus) joinButtonClickEvent;

  const MemberRegistrationWidget(
      {Key? key,
      required this.accountStatus,
      required this.joinButtonClickEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
          child: Column(children: [
            const Text(
              '歡迎加入鏡週刊',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: appColor,
              ),
            ),
            const Text(
              '會員專區',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: appColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '即日起加入年費會員  月月抽sony旗艦機',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff9B9B9B),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: appColor),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    '限時優惠每月\$50元',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '全站看到飽',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: appColor,
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                      ),
                      child: SizedBox(
                        width: Get.width,
                        child: Center(
                          child: Text(
                            accountStatus==AccountStatus.loggedIn ? '成為 Premium 會員' : '加入 Premium 會員',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () => joinButtonClickEvent(accountStatus)),
                ],
              ),
            ),
            if (accountStatus==AccountStatus.notLoggedIn) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: const Text(
                      '立即登入',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => joinButtonClickEvent(accountStatus),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '享專屬優惠',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ]),
        ));
  }
}
