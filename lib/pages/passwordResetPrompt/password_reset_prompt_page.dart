import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/passwordResetPrompt/password_reset_prompt_widget.dart';

class PasswordResetPromptPage extends StatelessWidget {
  final String email;
  const PasswordResetPromptPage({
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: PasswordResetPromptWidget(email: email),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('Email登入'),
      backgroundColor: appColor,
    );
  }
}
