import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberContactInfoBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class DistrictPicker extends StatefulWidget {
  final MemberContactInfoBloc memberContactInfoBloc;
  DistrictPicker({
    @required this.memberContactInfoBloc,
  });

  @override
  _DistrictPickerState createState() => _DistrictPickerState();
}

class _DistrictPickerState extends State<DistrictPicker> {
  bool _isPickerActivated;
  String _district;
  List<Widget> _districtListWidget;

  @override
  void initState() {
    _isPickerActivated = false;
    _district = widget.memberContactInfoBloc.editMember.contactAddress.district;
    setDistrictListWidget();
    super.initState();
  }

  @override
  void didUpdateWidget(DistrictPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _district = widget.memberContactInfoBloc.editMember.contactAddress.district;
    setDistrictListWidget();
  }

  setDistrictListWidget() {
    _districtListWidget = List<Widget>();
    widget.memberContactInfoBloc.cityList.forEach(
      (city) { 
        if(city.name == widget.memberContactInfoBloc.editMember.contactAddress.city) {
          city.districtList.forEach(
            (district) { 
              _districtListWidget.add(Text(district.name));
            }
          );
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
              if(widget.memberContactInfoBloc.editMember.contactAddress.country != null && 
              widget.memberContactInfoBloc.editMember.contactAddress.country == '臺灣' && 
              widget.memberContactInfoBloc.editMember.contactAddress.city != null) {
                setState(() {
                  _isPickerActivated = true;
                  _showPicker(pickerHeight, widget.memberContactInfoBloc);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _showPicker(double height, MemberContactInfoBloc memberContactInfoBloc) async{
    int cityIndex = memberContactInfoBloc.cityList.findIndexByName(
      memberContactInfoBloc.editMember.contactAddress.city
    );

    int targetIndex = _district == null || cityIndex == null
    ? 0
    : memberContactInfoBloc.cityList[cityIndex].districtList.findIndexByName(_district);

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
                        _district = memberContactInfoBloc.cityList[cityIndex].districtList[targetIndex].name;
                        memberContactInfoBloc.editMember.contactAddress.district = _district;
                        memberContactInfoBloc.sinkToAdd(ApiResponse.completed(memberContactInfoBloc.editMember));
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