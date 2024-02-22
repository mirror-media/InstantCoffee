import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/date_time_format.dart';
class BirthdayPicker extends StatefulWidget {
  final String? birthday;
  final ValueChanged<String?>? onBirthdayChange;
  const BirthdayPicker({this.birthday, this.onBirthdayChange});

  @override
  _BirthdayPickerState createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  bool _isPickerActivated = false;
  String? _birthday;

  @override
  void initState() {
    _birthday = widget.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var pickerHeight = MediaQuery.of(context).size.height / 3;

    return Container(
      color: _isPickerActivated ? const Color(0xFFF7FEFF) : Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              '出生',
              style: TextStyle(
                fontSize: 13,
                color: _isPickerActivated ? appColor : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          InkWell(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: !_isPickerActivated ? Colors.grey : appColor,
                    width: 1.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Text(
                  _birthday ?? 'YYYY-MM-DD',
                  style: TextStyle(
                    color: _birthday == null ? Colors.grey : Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _isPickerActivated = true;
                _showPicker(pickerHeight, widget.onBirthdayChange);
              });
            },
          ),
        ],
      ),
    );
  }

  _showPicker(double height, ValueChanged<String?>? onBirthdayChange) async {
    DateTime targetDateTime =
        DateTimeFormat.changeBirthdayStringToDatetime(_birthday) ??
            DateTime(1911, 1, 1);
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 48 + height,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                      InkWell(
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              '完成',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _birthday =
                                  DateTimeFormat.changeDatetimeToIso8601String(
                                      targetDateTime);
                              if (onBirthdayChange != null) {
                                onBirthdayChange(_birthday);
                              }
                              Navigator.pop(context);
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: height,
                  child: CupertinoDatePicker(
                    backgroundColor: const Color(0x00f8f8f9),
                    initialDateTime: targetDateTime,
                    minuteInterval: 1,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      targetDateTime = dateTime;
                    },
                  ),
                ),
              ],
            ),
          );
        });
    setState(() {
      _isPickerActivated = false;
    });
  }
}
