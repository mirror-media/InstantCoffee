import 'package:flutter/material.dart';

class MagazineListLabel extends StatelessWidget {
  final String label;
  const MagazineListLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      color: const Color.fromRGBO(248, 248, 249, 1),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 36.0, bottom: 12.0, left: 24.0, right: 24.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
