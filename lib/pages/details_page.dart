import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';
import '../helpers/url_launcher.dart';
import '../models/story.dart';

class DetailPage extends StatelessWidget {
  final Story record;

  const DetailPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(record.title ?? StringDefault.valueNullDefault),
        ),
        body: ListView(children: <Widget>[
          Hero(
            tag: "avatar_${record.title}",
            child: Image.network(
              record.heroImage ?? StringDefault.valueNullDefault,
            ),
          ),
          GestureDetector(
              onTap: () {
                URLLauncher().launchURL(
                    "https://www.mirrormedia.mg/story/${record.slug}");
              },
              child: Container(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    // First child in the Row for the name and the
                    Expanded(
                      // Name and Address are in the same column
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code to create the view for name.
                          Container(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              record.title ?? StringDefault.valueNullDefault,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Code to create the view for address.
                          Text(
                            "日期: ${record.publishedDate}",
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                    Icon(
                      Icons.phone,
                      color: Colors.red[500],
                    ),
                    Text(' ${record.title}'),
                  ],
                ),
              )),
        ]));
  }
}
