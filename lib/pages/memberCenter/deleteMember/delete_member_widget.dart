import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/cubit.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/state.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeleteMemberWidget extends StatefulWidget {
  final String israfelId;
  const DeleteMemberWidget({
    required this.israfelId,
  });

  @override
  _DeleteMemberWidgetState createState() => _DeleteMemberWidgetState();
}

class _DeleteMemberWidgetState extends State<DeleteMemberWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteMember() {
    context.read<DeleteMemberCubit>().deleteMember(widget.israfelId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteMemberCubit, DeleteMemberState>(
        listener: (context, state) {
      if (state is DeleteMemberSuccess) {
        context.read<MemberBloc>().add(UpdateSubscriptionType(
            isLogin: false, israfelId: null, subscriptionType: null));
      }
    }, builder: (context, state) {
      if (state is DeleteMemberInitState) {
        return Scaffold(
          appBar: _buildBar(context),
          body: _askingDeleteMemberWidget(context),
        );
      }

      if (state is DeleteMemberSuccess) {
        return Scaffold(
          appBar: _buildBar(context, isDeletedSuccessfully: true),
          body: _deletingMemberSuccessWidget(context),
        );
      }

      if (state is DeleteMemberError) {
        return Scaffold(
          appBar: _buildBar(context),
          body: _deletingMemberErrorWidget(context),
        );
      }

      // state is DeleteMemberLoading
      return Scaffold(
        appBar: _buildBar(context),
        body: _loadingWidget(),
      );
    });
  }

  PreferredSizeWidget _buildBar(BuildContext context,
      {bool isDeletedSuccessfully = false}) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (isDeletedSuccessfully) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              Navigator.of(context).pop();
            }
          }),
      centerTitle: true,
      title: const Text('會員中心'),
      backgroundColor: appColor,
    );
  }

  Widget _askingDeleteMemberWidget(BuildContext context) {
    String? email = _auth.currentUser?.email;
    return ListView(
      children: [
        const SizedBox(height: 72),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '確定要刪除帳號？',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '您的會員帳號為：$email',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '提醒您，刪除後即無法復原。若您有訂閱會員專區單篇文章，刪除帳號將導致無法繼續閱讀購買文章。',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton('不刪除，回首頁', context),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _deleteMemberButton(context),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _deletingMemberSuccessWidget(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 72),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '已刪除帳號',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '我們已經刪除你的會員帳號。',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '謝謝你使用鏡週刊的會員服務，很遺憾要刪除你的帳號，如果希望再次使用的話，歡迎再次註冊！',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton('回首頁', context),
        ),
      ],
    );
  }

  Widget _deletingMemberErrorWidget(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 72),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '刪除失敗',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '請重新登入，或是聯繫客服信箱',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        InkWell(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  mirrorMediaServiceEmail,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: mirrorMediaServiceEmail,
              );

              if (await canLaunchUrlString(emailLaunchUri.toString())) {
                await launchUrlString(emailLaunchUri.toString());
              } else {
                throw 'Could not launch $mirrorMediaServiceEmail';
              }
            }),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '致電(02)6633-3966由專人為您服務',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton('回首頁', context),
        ),
      ],
    );
  }

  Widget _backToHomeButton(String text, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }

  Widget _deleteMemberButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          //color: appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Center(
          child: Text(
            '確認刪除',
            style: TextStyle(
              fontSize: 17,
              color: Colors.red,
            ),
          ),
        ),
      ),
      onTap: () => _deleteMember(),
    );
  }
}
