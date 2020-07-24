import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readr_app/models/newsMarqueeService.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/newsMarqueeWidget.dart';

class NewsMarquee extends StatefulWidget {
  @override
  _NewsMarqueeState createState() => _NewsMarqueeState();
}

class _NewsMarqueeState extends State<NewsMarquee> {
  RecordList _newsMarqueeList;

  @override
  void initState() {
    _setNewsMarqueeList();
    super.initState();
  }

  void _setNewsMarqueeList() async {
    String jsonString = await NewsMarqueeService().loadData();
    final jsonObject = json.decode(jsonString);
    setState(() {
      _newsMarqueeList = RecordList.fromJson(jsonObject["_items"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _newsMarqueeList == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: NewsMarqueeWidget(
              recordList: _newsMarqueeList,
            ),
          );
  }
}
