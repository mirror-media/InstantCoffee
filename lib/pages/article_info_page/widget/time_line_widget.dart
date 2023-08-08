import 'package:flutter/material.dart';

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({Key? key, required this.title, required this.time}) : super(key: key);
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(width: 8),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
