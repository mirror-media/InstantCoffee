import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/countryList.dart';
import 'package:readr_app/models/member.dart';

class CountryPicker extends StatefulWidget {
  final CountryList countryList;
  final Member member;
  CountryPicker({
    @required this.countryList,
    @required this.member,
  });

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  bool _isPickerActivated;
  String _country;
  List<Widget> _countryListWidget;

  @override
  void initState() {
    _isPickerActivated = false;
    _country = widget.member.contactAddress.country;
    _setCountryListWidget();
    super.initState();
  }

  _changeMember(Member member) {
    context.read<EditMemberContactInfoBloc>().add(
      ChangeMember(member: member)
    );
  }

  _setCountryListWidget() {
    _countryListWidget = [];
    widget.countryList.forEach(
      (country) { 
        _countryListWidget.add(Text(country.taiwanName));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var pickerHeight = MediaQuery.of(context).size.height/3;

    return Container(
      color: _isPickerActivated
      ? Color(0xFFF7FEFF)
      : Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              '聯絡地址',
              style: TextStyle(
                fontSize: 13,
                color: _isPickerActivated
                ? appColor
                : Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 4.0),
          InkWell(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: !_isPickerActivated
                    ? Colors.grey
                    : appColor,
                    width: 1.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _country ?? '國家',
                      style: TextStyle(
                        color: _country == null
                        ? Colors.grey
                        : Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    _isPickerActivated
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _isPickerActivated = true;
                _showPicker(pickerHeight, widget.countryList, widget.member);
              });
            },
          ),
        ],
      ),
    );
  }

  _showPicker(double height, CountryList countryList, Member member) async{
    int targetIndex = _country == null
    ? countryList.findIndexByTaiwanName('臺灣')
    : countryList.findIndexByTaiwanName(_country);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 48+height,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      }
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          '完成',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          _country = countryList[targetIndex].taiwanName;
                          member.contactAddress.country = _country;
                          if(_country != '臺灣') {
                            member.contactAddress.city = null;
                            member.contactAddress.district = null;
                          }
                          _changeMember(member);
                          Navigator.pop(context);
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: targetIndex),
                  backgroundColor: const Color(0xF8F8F9),
                  onSelectedItemChanged: (value) {
                    targetIndex = value;
                  },
                  itemExtent: 32.0,
                  children: _countryListWidget,
                ),
              ),
            ],
          ),
        );
      }
    );
    setState(() {
      _isPickerActivated = false;
    });
  }
}