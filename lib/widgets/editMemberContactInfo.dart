import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/blocs/memberBloc.dart';
import 'package:readr_app/blocs/memberContactInfoBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/widgets/cityPicker.dart';
import 'package:readr_app/widgets/countryPicker.dart';
import 'package:readr_app/widgets/districtPicker.dart';

class EditMemberContactInfo extends StatefulWidget {
  final Member member;
  final MemberBloc memberBloc;
  EditMemberContactInfo({
    @required this.member,
    @required this.memberBloc,
  });
  
  @override
  _EditMemberContactInfoState createState() => _EditMemberContactInfoState();
}

class _EditMemberContactInfoState extends State<EditMemberContactInfo> {
  MemberContactInfoBloc _memberContactInfoBloc;

  @override
  void initState() {
    _memberContactInfoBloc = MemberContactInfoBloc(widget.member.copy());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<Member>>(
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
          Text('修改聯絡資訊'),
          FlatButton(
            child: Text(
              '儲存',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              widget.memberBloc.saveMember(widget.member, _memberContactInfoBloc.editMember, isProfile: false);
              Navigator.of(context).pop();
            }
          ),
        ],
      ),
    );
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
          child: _adressTextField(memberContactInfoBloc.editMember),
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

  Widget _adressTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: TextFormField(
        initialValue: member.contactAddress.address,
        keyboardType: TextInputType.number,
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
