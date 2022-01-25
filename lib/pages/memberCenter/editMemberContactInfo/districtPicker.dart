import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/contact/city.dart';
import 'package:readr_app/models/contact/district.dart';
import 'package:readr_app/models/member.dart';

class DistrictPicker extends StatefulWidget {
  final List<City> cityList;
  final Member member;
  DistrictPicker({
    required this.cityList,
    required this.member,
  });

  @override
  _DistrictPickerState createState() => _DistrictPickerState();
}

class _DistrictPickerState extends State<DistrictPicker> {
  bool _isPickerActivated = false;
  List<Widget> _districtListWidget = [];

  String? _district;

  @override
  void initState() {
    _district = widget.member.contactAddress.district;
    _setDistrictListWidget();
    super.initState();
  }

  @override
  void didUpdateWidget(DistrictPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _district = widget.member.contactAddress.district;
    _setDistrictListWidget();
  }

  _changeMember(Member member) {
    context.read<EditMemberContactInfoBloc>().add(
      ChangeMember(member: member)
    );
  }

  _setDistrictListWidget() {
    widget.cityList.forEach(
      (city) { 
        if(city.name == widget.member.contactAddress.city) {
          if(city.districtList != null) {
            city.districtList!.forEach(
              (district) { 
                _districtListWidget.add(Text(district.name));
              }
            );
          }
        }
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
                      _district ?? '行政區',
                      style: TextStyle(
                        color: _district == null
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
              if(widget.member.contactAddress.country != null && 
              widget.member.contactAddress.country == '臺灣' && 
              widget.member.contactAddress.city != null) {
                setState(() {
                  _isPickerActivated = true;
                  _showPicker(pickerHeight, widget.cityList, widget.member);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _showPicker(double height, List<City> cityList, Member member) async{
    int? cityIndex = member.contactAddress.city == null
    ? null
    : City.findCityListIndexByName(
        cityList,
        member.contactAddress.city!
      );

    int targetIndex = _district == null || cityIndex == null
    ? 0
    : District.findDistrictListIndexByName(cityList[cityIndex].districtList!, _district!);

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
                        _district = cityList[cityIndex!].districtList![targetIndex].name;
                        member.contactAddress.district = _district;
                        _changeMember(member);
                        Navigator.pop(context);
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
                  children: _districtListWidget,
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