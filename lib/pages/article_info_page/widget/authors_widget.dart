import 'package:flutter/material.dart';
import 'package:readr_app/data/enum/author_occupation.dart';

import '../../../models/author_occupation.dart';

class AuthorsWidget extends StatelessWidget {
  final List<AuthorOccupationModel> authorList;
  const  AuthorsWidget({Key? key, required this.authorList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: authorList.map((author) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  author.authorOccupation.displayText(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  height: 15,
                  child: VerticalDivider(
                    color: Colors.black54,
                    width: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  author.name,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8)
          ],
        );
      }).toList(),
    );
  }
}