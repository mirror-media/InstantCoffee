import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/userContactInfoBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class DistrictPicker extends StatefulWidget {
  final UserContactInfoBloc userContactInfoBloc;
  DistrictPicker({
    @required this.userContactInfoBloc,
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
    _district = widget.userContactInfoBloc.editUserData.contactAddress.district;
    setDistrictListWidget();
    super.initState();
  }

  @override
  void didUpdateWidget(DistrictPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _district = widget.userContactInfoBloc.editUserData.contactAddress.district;
    setDistrictListWidget();
  }

  setDistrictListWidget() {
    _districtListWidget = List<Widget>();
    widget.userContactInfoBloc.cityList.forEach(
      (city) { 
        if(city.name == widget.userContactInfoBloc.editUserData.contactAddress.city) {
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
              if(widget.userContactInfoBloc.editUserData.contactAddress.country != null && 
              widget.userContactInfoBloc.editUserData.contactAddress.country == '臺灣' && 
              widget.userContactInfoBloc.editUserData.contactAddress.city != null) {
                setState(() {
                  _isPickerActivated = true;
                  _showPicker(pickerHeight, widget.userContactInfoBloc);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _showPicker(double height, UserContactInfoBloc userContactInfoBloc) async{
    int cityIndex = userContactInfoBloc.cityList.findIndexByName(
      userContactInfoBloc.editUserData.contactAddress.city
    );

    int targetIndex = _district == null || cityIndex == null
    ? 0
    : userContactInfoBloc.cityList[cityIndex].districtList.findIndexByName(_district);

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
                        _district = userContactInfoBloc.cityList[cityIndex].districtList[targetIndex].name;
                        userContactInfoBloc.editUserData.contactAddress.district = _district;
                        userContactInfoBloc.sinkToAdd(ApiResponse.completed(userContactInfoBloc.editUserData));
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