import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/models/people.dart';

class PersonList extends StatelessWidget {
  const PersonList(
      {Key? key,
      required this.peopleList,
      required this.title,
      this.isExternal = false})
      : super(key: key);

  final String title;
  final List<People> peopleList;
  final bool? isExternal;

  Widget personGridItem(String name) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF054F77),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isExternal == true
                ? Row(children: [
                    Image.asset(
                      ImagePath.mmLogo,
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(width: 16)
                  ])
                : const SizedBox(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0x88000000),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ...peopleList.map(
              (e) => Row(
                children: [
                  Text(
                    e.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF054F77),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
