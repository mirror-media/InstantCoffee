import 'package:flutter/material.dart';
import 'helpers/URLLauncher.dart';
import 'models/Story.dart';

class DetailPage extends StatelessWidget {
  final Story record;
  DetailPage({this.record});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(record.title),
        ),
        body: new ListView(children: <Widget>[
          Hero(
            tag: "avatar_" + record.title,
            child: new Image.network(
              record.heroImage,
            ),
          ),
          GestureDetector(
              onTap: () {
                URLLauncher().launchURL(
                    "https://www.mirrormedia.mg/story/" + record.slug);
              },
              child: new Container(
                padding: const EdgeInsets.all(32.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code to create the view for name.
                          new Container(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: new Text(
                              record.title,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Code to create the view for address.
                          new Text(
                            "日期: " + record.publishedDate,
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                    new Icon(
                      Icons.phone,
                      color: Colors.red[500],
                    ),
                    new Text(' ${record.title}'),
                  ],
                ),
              )),
        ]));
  }
}
