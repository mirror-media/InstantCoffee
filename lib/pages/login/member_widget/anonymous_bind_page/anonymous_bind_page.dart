import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/login/member_widget/anonymous_bind_page/anonymous_bind_controller.dart';
import 'package:readr_app/widgets/third_party_login_button.dart';

class AnonymousBindPage extends StatelessWidget {
  AnonymousBindPage({Key? key}) : super(key: key);
  final controller = Get.put(AnonymousBindController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('註冊正式會員'),
        backgroundColor: appColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ThirdPartyLoginButton(
                  onTapFunction: controller.googleBindButtonClickEvent,
                  contentText: '使用 Google 帳號繼續',
                  imageLocation: ImagePath.googleLoginIcon),
              const SizedBox(height: 12),
              ThirdPartyLoginButton(
                  onTapFunction: controller.facebookButtonClickEvent,
                  contentText: '使用 Facebook 帳號繼續',
                  imageLocation: ImagePath.facebookLoginIcon),
              const SizedBox(height: 12),
              ThirdPartyLoginButton(
                  onTapFunction: controller.appleBindButtonClickEvent,
                  contentText: '使用 Apple 帳號繼續',
                  imageLocation: ImagePath.appleLoginIcon),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '或',
                      style: TextStyle(color: Color(0x4D000000)),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Obx(() {
                  final errorMessage = controller.rxnEmailErrorMessage.value;
                  return TextField(
                    controller: controller.eMailTextEditingController,
                    decoration: InputDecoration(
                      hintText: '以 Email 繼續',
                      hintStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      errorText: errorMessage,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: appColor, width: 1.5),
                      ),
                    ),
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isNextButtonEnable = controller.rxIsHaveEmail.value;
                  return ElevatedButton(
                    onPressed: isNextButtonEnable == true
                        ? controller.nextButtonClickEvent
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: appColor,
                      disabledForegroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      '下一步',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
