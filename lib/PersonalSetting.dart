import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:reorderables/reorderables.dart';
import 'helpers/Constants.dart';
import 'models/Section.dart';
import 'models/SectionList.dart';
import 'models/SectionService.dart';

class PersonalSetting extends StatefulWidget {
  PersonalSetting({Key key}) : super(key: key);

  @override
  _PersonalSetting createState() => _PersonalSetting();
}

class _PersonalSetting extends State<PersonalSetting> {
  final LocalStorage storage = new LocalStorage('setting');
  SectionList sectionItems = new SectionList();
  Map notificationSetting = new Map();
  bool isSwitched;
  Widget _appBarTitle = new Text(settingPageTitle);

  @override
  void initState() {
    // TODO: implement initState
    this.notificationSetting = storage.getItem("notification");
    this.sectionItems = SectionList.fromJson(json.decode(storage.getItem("sections")));
    
    if (this.notificationSetting == null) {
      _initNotification();
    }
    if (this.sectionItems == null) {
      _getSections();
    }
    super.initState();
  }
  
  void _initNotification() async {
    //TODO add the default value to local storage and handle the Switch widget
    String jsonSetting = await rootBundle.loadString('assets/data/defaultNotification.json');
    setState(() {
      this.notificationSetting = json.decode(jsonSetting);
      this.storage.setItem("notification", this.notificationSetting);
    });
  }

  void _getSections() async {
    sectionItems = new SectionList();
    SectionList allSections = new SectionList();
    allSections = await SectionService().loadSections();
    this.sectionItems.sections = [];
    setState(() {
      allSections.sections.sort((a,b) => a.order.compareTo(b.order));
      int order = 1;
      for (Section section in allSections.sections) {
        section.order = order;
        this.sectionItems.sections.add(section);
        order++;
      }
      this.storage.setItem("sections", this.sectionItems.toJson());
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body:   _buildNotificationSetting()         
    );
  }

  List<Widget> _buildOrderSections() {
    List<Widget> reorderSections = new List<Widget>();
      for (Section sectionItem in this.sectionItems.sections) {
        reorderSections.add(Row(key: ValueKey(sectionItem.name), children: [Text(sectionItem.title), Icon(Icons.menu)],));
      }
    return reorderSections;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      for (int i = 0; i < sectionItems.sections.length; i++) {
        if (sectionItems.sections[i].order == oldIndex) {
          sectionItems.sections[i].order == newIndex;
        } else {
          if (oldIndex > newIndex) {
            if (sectionItems.sections[i].order >= newIndex) {
              sectionItems.sections[i].order++;
            }
          } else if (oldIndex < newIndex) {
            if (sectionItems.sections[i].order > oldIndex && sectionItems.sections[i].order < newIndex) {
              sectionItems.sections[i].order--;
            }
          }
        }
      }
    });
    for (Section section in sectionItems.sections) {
      print(section.title + section.order.toString());
    }
  }

  Widget _buildNotificationSetting() {
    List<Widget> notificationSwitch = new List<Widget>();
    if (notificationSetting != null) {    
      this.notificationSetting.forEach(
        (k, v) => notificationSwitch.add(_itemGenerate(k, v))
      );
      //notificationSwitch.add(
      return  ReorderableColumn(
        header: Column( children: notificationSwitch ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildOrderSections(),
        onReorder: (int oldIndex, int newIndex) { _onReorder(oldIndex, newIndex); } );
      //);
      //return notificationSwitch;
    } else {
      return null;
    }
  }
  
  Widget _buildSubItems(String part, dynamic items) {
    List<Widget> menu = List<Widget>();
    List<Widget> columnCheckbox = List<Widget>();
    int columnCount = 1;
    for (String k in items.keys) {
      columnCheckbox.add(
        new Row(
          children:[
            Checkbox(
              value: items[k]["value"], 
              onChanged: (value) {
                setState(() {
                  items[k]["value"] = value;
                  this.notificationSetting[part]["subitems"][k]["value"] = value;
                }); 
                storage.setItem("notification", this.notificationSetting); 
              }, 
            ),
            Text(items[k]["title"]),
          ]
        )
      );
      if (columnCount == 3) {
        menu.add(new Row(children: columnCheckbox));
        columnCount = 1;
        columnCheckbox = List<Widget>();
      } else {
        columnCount++;
      }
    }
    return Column(
      children: menu,
    );
  }

  Widget _itemGenerate(String k, dynamic v) {
    Widget formItem;
    switch (k) {
      case "horoscope": {
        Widget checkboxes = _buildSubItems(k,v["subitems"]);
        formItem = new Column(
          children: [
            Row(
              children: [
                Text(v["title"]),
                Switch(
                  onChanged: (value) { 
                    setState(() => this.notificationSetting[k]["value"] = value ); 
                    storage.setItem("notification", this.notificationSetting); 
                  }, 
                  value: v["value"],
                  activeColor: themeColor,
                ),
              ]
            ),
            checkboxes,
          ]
        );
      }
      break;
      default: {
       formItem = new Row(
          children: [
            Text(v["title"]),
            Switch(
              onChanged: (value) { 
                setState(() => this.notificationSetting[k]["value"] = value ); 
                storage.setItem("notification", this.notificationSetting);
                //print(this.notificationSetting);
              }, 
              value: v["value"],
              activeColor: themeColor,
            ),
          ]
        );
      }
      break;
    }
    return formItem;
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      backgroundColor: appColor,
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => {},
        ),
      ],
    );
  }
}