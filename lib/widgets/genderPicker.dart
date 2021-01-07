import 'package:flutter/material.dart';
import 'package:readr_app/models/userData.dart';

class GenderPicker extends StatefulWidget {
  final Gender gender;
  final ValueChanged<Gender> onGenderChange;
  GenderPicker({
    this.gender = Gender.A_0,
    this.onGenderChange,
  });

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String male = '男';
  String female = '女';
  String unknown = '不透露';
  Gender _targetGender = Gender.A_0;

  @override
  void initState() {
    _targetGender = widget.gender;
    super.initState();
  }

  void genderChange(Gender gender) {
    setState(() {
      widget.onGenderChange(gender);
      _targetGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性別',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.A_1,
                  groupValue: _targetGender,
                  onChanged: genderChange,
                ),
                Text(
                  male,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.A_2,
                  groupValue: _targetGender,
                  onChanged: genderChange,
                ),
                Text(
                  female,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.A_3,
                  groupValue: _targetGender,
                  onChanged: genderChange,
                ),
                Text(
                  unknown,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}