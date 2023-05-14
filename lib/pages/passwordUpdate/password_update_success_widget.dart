import 'package:flutter/material.dart';

class PasswordUpdateSuccessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 48),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '設定成功',
              style: TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '請重新登入，以享受鏡週刊會員完整服務。',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backButton(context),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Center(
            child: Text(
              '重新登入',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
        ),
        onTap: () => Navigator.of(context).pop());
  }
}
