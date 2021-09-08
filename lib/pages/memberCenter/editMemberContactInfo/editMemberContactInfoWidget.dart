import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/states.dart';
import 'package:readr_app/blocs/memberContactInfoBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/cityPicker.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/countryPicker.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/districtPicker.dart';

class EditMemberContactInfoWidget extends StatefulWidget {
  @override
  _EditMemberContactInfoWidgetState createState() => _EditMemberContactInfoWidgetState();
}

class _EditMemberContactInfoWidgetState extends State<EditMemberContactInfoWidget> {
  MemberContactInfoBloc _memberContactInfoBloc;

  @override
  void initState() {
    _fetchMemberContactInfo();
    super.initState();
  }

  _fetchMemberContactInfo() {
    context.read<EditMemberContactInfoBloc>().add(
      FetchMemberContactInfo()
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMemberContactInfoBloc, EditMemberContactInfoState>(
      builder: (BuildContext context, EditMemberContactInfoState state) {
        if (state is MemberLoadedError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Container();
        }

        if (state is MemberLoaded) {
          Member member = state.member;
          _memberContactInfoBloc = MemberContactInfoBloc(member.copy());
          return StreamBuilder<ApiResponse<Member>>(
            stream: _memberContactInfoBloc.memberStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Center(child: CircularProgressIndicator());
                    break;

                  case Status.LOADINGMORE:
                  case Status.COMPLETED:
                    return _buildBody(_memberContactInfoBloc);
                    break;

                  case Status.ERROR:
                    return Container();
                    break;
                }
              }
              return Container();
            },
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

  Widget _buildBody(MemberContactInfoBloc memberContactInfoBloc) {
    return ListView(
      children: [
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _phoneTextField(memberContactInfoBloc.editMember),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: CountryPicker(
            memberContactInfoBloc: memberContactInfoBloc,
          ),
        ),
        if(memberContactInfoBloc.editMember.contactAddress.country == '臺灣')...[
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CityPicker(
                    memberContactInfoBloc: memberContactInfoBloc,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: DistrictPicker(
                    memberContactInfoBloc: memberContactInfoBloc,
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _addressTextField(memberContactInfoBloc.editMember),
        ),
      ],
    );
  }

  Widget _phoneTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              '手機',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          TextFormField(
            initialValue: member.phoneNumber,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              hintText: '0999999999',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            onChanged: (value){
              member.phoneNumber = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _addressTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: TextFormField(
        initialValue: member.contactAddress.address,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          hintText: '自填地址',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
        ),
        onChanged: (value){
          member.contactAddress.address = value;
        },
      ),
    );
  }
}