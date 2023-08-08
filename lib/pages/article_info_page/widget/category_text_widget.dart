import 'package:flutter/material.dart';
import '../../../helpers/data_constants.dart';

class CategoryTextWidget extends StatelessWidget {
  final List<String> categoriesList;
  const CategoryTextWidget({Key? key, required this.categoriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/image/mm_logo_for_story.png',
          width: 32.0,
          height: 32.0,
        ),
        const SizedBox(
          width: 8,
        ),
        ...categoriesList.map((category) {
          return Row(children: [
            Text(
              category,
              style: const TextStyle(fontSize: 16, color: appColor),
            ),
            const SizedBox(
              width: 8,
            ),
            const SizedBox(
              height: 15,
              child: VerticalDivider(
                color: Colors.black54,
                width: 2,
                thickness: 1,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ]);
        }).toList(),
      ],
    );
  }
}
