import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/userData.dart';
import 'package:readr_app/widgets/birthdayPicker.dart';
import 'package:readr_app/widgets/genderPicker.dart';

class EditUserProfile extends StatefulWidget {
  final UserData userData;
  EditUserProfile({
    @required this.userData,
  });

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  UserData _editUserData;
  @override
  void initState() {
    _editUserData = widget.userData.copy();
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
            child: _emailSection(_editUserData.email),
          ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _nameTextField(_editUserData),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: GenderPicker(
              gender: _editUserData.gender,
              onGenderChange: (Gender gender){
                _editUserData.gender = gender;
              },
            ),
          ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: BirthdayPicker(
              birthday: _editUserData.birthday,
              onBirthdayChange: (String birthday){
                _editUserData.birthday = birthday;
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
              // saveUserDate
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

  Widget _nameTextField(UserData userData) {
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
            initialValue: userData.name,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              hintText: "王大明",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            onChanged: (value){
              userData.name = value;
            },
          ),
        ],
      ),
    );
  }
}