import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/birthdayPicker.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/genderPicker.dart';

class EditMemberProfileWidget extends StatefulWidget {
  @override
  _EditMemberProfileWidgetState createState() => _EditMemberProfileWidgetState();
}

class _EditMemberProfileWidgetState extends State<EditMemberProfileWidget> {
  @override
  void initState() {
    _fetchMemberProfile();
    super.initState();
  }

  _fetchMemberProfile() {
    context.read<EditMemberProfileBloc>().add(
      FetchMemberProfile()
    );
  }
  
  _updateMemberProfile(Member member) {
    context.read<EditMemberProfileBloc>().add(
      UpdateMemberProfile(editMember: member)
    );
  }

  void _delayNavigatorPop() async{
    await Future.delayed(Duration());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMemberProfileBloc, EditMemberProfileState>(
      builder: (BuildContext context, EditMemberProfileState state) {
        if (state is MemberLoadedError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Scaffold(
            appBar: _buildBar(context, null),
            body: Container()
          );
        }

        if (state is MemberLoaded) {
          Member member = state.member;

          return Scaffold(
            appBar: _buildBar(context, member),
            body: _memberProfileForm(member),
          );
        }

        if (state is SavingLoading) {
          Member member = state.member;

          return Scaffold(
            appBar: _buildBar(context, member, isSaveLoading: true),
            body: _memberProfileForm(member),
          );
        }

        if (state is SavingSuccess) {
          context.read<EditMemberProfileBloc>().memberProfileUpdateSuccess = true;
          _delayNavigatorPop();
          Member member = state.member;
          
          return Scaffold(
            appBar: _buildBar(context, member),
            body: _memberProfileForm(member),
          );
        }

        if (state is SavingError) {
          context.read<EditMemberProfileBloc>().memberProfileUpdateSuccess = false;
          _delayNavigatorPop();
          Member member = state.member;

          return Scaffold(
            appBar: _buildBar(context, member),
            body: _memberProfileForm(member),
          );
        }

        // state is Init, Loading
        return Scaffold(
          appBar: _buildBar(context, null),
          body: _loadingWidget()
        );
      }
    );
  }

  Widget _buildBar(
    BuildContext context, 
    Member member, 
    { bool isSaveLoading = false }
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColor,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text('修改個人資料'),
          if(!isSaveLoading)
            TextButton(
              child: Text(
                '儲存',
                style: TextStyle(
                  fontSize: 16, 
                  color: member == null
                  ? Colors.grey
                  : Colors.white
                ),
              ),
              onPressed: member == null
              ? null
              : () {
                  _updateMemberProfile(member);
                  print('save');
                },
            ),
          if(isSaveLoading)
            TextButton(
              child: SpinKitRipple(color: Colors.white, size: 32,),
              onPressed: null,
            ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _memberProfileForm(Member member) {
    bool hideEmail = false;
    if(member.email != null){
      excludeEmail.forEach((element) {
        if(member.email.contains(element)) hideEmail = true;
      });
    }
    else{
      hideEmail = true;
    }
    return ListView(
      children: [
        SizedBox(height: 32),
        // privaterelay.appleid.com is a anonymous email provided by apple
        if(!hideEmail)
        ...[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailSection(member.email),
          ),
          SizedBox(height: 28),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _nameTextField(member),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: GenderPicker(
            gender: member.gender,
            onGenderChange: (Gender gender){
              member.gender = gender;
            },
          ),
        ),
        SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: BirthdayPicker(
            birthday: member.birthday,
            onBirthdayChange: (String birthday){
              member.birthday = birthday;
            },
          ),
        ),
      ],
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