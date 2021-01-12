import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/widgets/birthdayPicker.dart';
import 'package:readr_app/widgets/genderPicker.dart';

class EditMemberProfile extends StatefulWidget {
  final Member member;
  final MemberBloc memberBloc;
  EditMemberProfile({
    @required this.member,
    @required this.memberBloc,
  });

  @override
  _EditMemberProfileState createState() => _EditMemberProfileState();
}

class _EditMemberProfileState extends State<EditMemberProfile> {
  Member _editMember;
  @override
  void initState() {
    _editMember = widget.member.copy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        children: [
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailSection(_editMember.email),
          ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _nameTextField(_editMember),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: GenderPicker(
              gender: _editMember.gender,
              onGenderChange: (Gender gender){
                _editMember.gender = gender;
              },
            ),
          ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: BirthdayPicker(
              birthday: _editMember.birthday,
              onBirthdayChange: (String birthday){
                _editMember.birthday = birthday;
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColor,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            child: Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text('修改個人資料'),
          FlatButton(
            child: Text(
              '儲存',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              widget.memberBloc.saveMember(widget.member, _editMember, isProfile: true);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _emailSection(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'email',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          email,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _nameTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              '姓名',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          TextFormField(
            initialValue: member.name,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              hintText: "王大明",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            onChanged: (value){
              member.name = value;
            },
          ),
        ],
      ),
    );
  }
}