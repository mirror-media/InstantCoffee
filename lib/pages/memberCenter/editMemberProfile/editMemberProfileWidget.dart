import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMemberProfileBloc, EditMemberProfileState>(
      builder: (BuildContext context, EditMemberProfileState state) {
        if (state is MemberLoadedError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Container();
        }

        if (state is MemberLoaded) {
          Member member = state.member;

          return ListView(
            children: [
              SizedBox(height: 32),
              // privaterelay.appleid.com is a anonymous email provided by apple
              if(member.email != null && !member.email.contains('privaterelay.appleid.com'))
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

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
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