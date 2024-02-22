import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/birthday_picker.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/gender_picker.dart';
import 'package:readr_app/widgets/logger.dart';
class EditMemberProfileWidget extends StatefulWidget {
  @override
  _EditMemberProfileWidgetState createState() =>
      _EditMemberProfileWidgetState();
}

class _EditMemberProfileWidgetState extends State<EditMemberProfileWidget>
    with Logger {
  @override
  void initState() {
    _fetchMemberProfile();
    super.initState();
  }

  _fetchMemberProfile() {
    context.read<EditMemberProfileBloc>().add(FetchMemberProfile());
  }

  _updateMemberProfile(Member member) {
    context
        .read<EditMemberProfileBloc>()
        .add(UpdateMemberProfile(editMember: member));
  }

  String _displayMemberEmail(String? inputEmail) {
    if (inputEmail == null ||
        // privaterelay.appleid.com is a anonymous email provided by apple
        inputEmail.contains('privaterelay.appleid.com') ||
        // when firebase email is null, it will create [0x0001] - xxxx in db
        inputEmail.contains('[0x0001] -')) {
      return '';
    }

    return inputEmail;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMemberProfileBloc, EditMemberProfileState>(
        builder: (BuildContext context, EditMemberProfileState state) {
      if (state is MemberLoadedError) {
        final error = state.error;
        debugLog('StoryError: ${error.message}');
        return Scaffold(appBar: _buildBar(context, null), body: Container());
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

      // state is Init, Loading
      return Scaffold(appBar: _buildBar(context, null), body: _loadingWidget());
    });
  }

  PreferredSizeWidget _buildBar(BuildContext context, Member? member,
      {bool isSaveLoading = false}) {
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
            child: const Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text('修改個人資料'),
          if (!isSaveLoading)
            TextButton(
              onPressed: member == null
                  ? null
                  : () {
                      _updateMemberProfile(member);
                      debugLog('save');
                    },
              child: Text(
                '儲存',
                style: TextStyle(
                    fontSize: 16,
                    color: member == null ? Colors.grey : Colors.white),
              ),
            ),
          if (isSaveLoading)
            const TextButton(
              onPressed: null,
              child: SpinKitRipple(
                color: Colors.white,
                size: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _memberProfileForm(Member member) {
    return ListView(
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailSection(_displayMemberEmail(member.email)),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _nameTextField(member),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: GenderPicker(
            gender: member.gender,
            onGenderChange: (Gender? gender) {
              member.gender = gender;
            },
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: BirthdayPicker(
            birthday: member.birthday,
            onBirthdayChange: (String? birthday) {
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
        const Text(
          'email',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: const TextStyle(
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
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
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
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              hintText: "王大明",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            onChanged: (value) {
              member.name = value;
            },
          ),
        ],
      ),
    );
  }
}
