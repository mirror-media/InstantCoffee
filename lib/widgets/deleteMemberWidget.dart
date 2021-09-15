import 'package:flutter/material.dart';
import 'package:readr_app/blocs/deleteMemberBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/deleteResponse.dart';
import 'package:readr_app/models/member.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteMemberWidget extends StatefulWidget {
  final Member member;
  DeleteMemberWidget({
    @required this.member,
  });

  @override
  _DeleteMemberWidgetState createState() => _DeleteMemberWidgetState();
}

class _DeleteMemberWidgetState extends State<DeleteMemberWidget> {
  DeleteMemberBloc _deleteMemberBloc;
  
  @override
  void initState() {
    _deleteMemberBloc = DeleteMemberBloc();
    super.initState();
  }

  @override
  void dispose() {
    _deleteMemberBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DeleteResponse<Member>>(
      initialData: DeleteResponse.completed(widget.member),
      stream: _deleteMemberBloc.deleteMemberStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.Complete:
              Member member = snapshot.data.data;
              return Scaffold(
                appBar: _buildBar(context, Status.Complete),
                body: _askingDeleteMemberWidget(
                  context, 
                  member,
                  _deleteMemberBloc
                ),
              );
              break;

            case Status.DeletingLoading:
              return Scaffold(
                appBar: _buildBar(context, Status.DeletingLoading),
                body: _loadingWidget()
              );
              break;

            case Status.DeletingSuccessfully:
              return Scaffold(
                appBar: _buildBar(context, Status.DeletingSuccessfully),
                body: _deletingMemberSuccessWidget(context)
              );
              break;

            case Status.DeletingError:
              return Scaffold(
                appBar: _buildBar(context, Status.DeletingError),
                body: _deletingMemberFailWidget(context)
              );
              break;
          }
        }
        return Container();
      }
    );
  }

  Widget _buildBar(BuildContext context, Status status) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          if(status == Status.DeletingSuccessfully) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pop();
          }
        }
      ),
      centerTitle: true,
      title: Text('會員中心'),
      backgroundColor: appColor,
    );
  }

  Widget _askingDeleteMemberWidget(BuildContext context, Member member, DeleteMemberBloc deleteMemberBloc) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '確定要刪除帳號？',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '您的會員帳號為：${member.email}',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '刪除後即無法復原',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '將無法享有鏡週刊會員獨享服務',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton('不刪除，回首頁', context),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _deleteMemberButton(
            context,
            deleteMemberBloc,
          ),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _deletingMemberSuccessWidget(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '已刪除帳號',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '我們已經刪除你的會員帳號',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 4.0, 24.0, 4.0),
            child: Text(
              '謝謝你使用鏡週刊的會員服務，很遺憾要刪除你的帳號，如果希望再次使用的話，歡迎再次註冊！',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton('回首頁', context),
        ),
      ],
    );
  }

  Widget _deletingMemberFailWidget(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '刪除失敗',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '請重新登入，或是聯繫客服',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        InkWell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                'E-MAIL: mm-onlineservice@mirrormedia.mg',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
          onTap: () async{
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'mm-onlineservice@mirrormedia.mg',
            );

            if (await canLaunch(emailLaunchUri.toString())) {
              await launch(emailLaunchUri.toString());
            } else {
              throw 'Could not launch mm-onlineservice@mirrormedia.mg';
            }
          }
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '(02)6633-3966',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '我們將有專人為您服務',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
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
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }

  Widget _deleteMemberButton(BuildContext context, DeleteMemberBloc deleteMemberBloc) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          //color: appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '確認刪除',
            style: TextStyle(
              fontSize: 17,
              color: Colors.red,
            ),
          ),
        ),
      ),
      onTap: () {
        deleteMemberBloc.deleteMember(widget.member.israfelId);
      },
    );
  }
}