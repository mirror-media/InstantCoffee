import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/models/NotificationSetting.dart';
import 'package:readr_app/models/NotificationSettingList.dart';

import 'helpers/Constants.dart';
import 'models/SectionList.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final LocalStorage storage = new LocalStorage('setting');
  List<NotificationSetting> notificationSettingList = new List<NotificationSetting>();
  SectionList sectionItems = new SectionList();

  @override
  void initState() {
    this.notificationSettingList = NotificationSettingList.fromJson(this.storage.getItem("notification"));

    if (this.notificationSettingList == null) {
      _initNotification();
    }
    super.initState();
  }

  void _initNotification() async {
    var jsonSetting = await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    setState(() {
      this.notificationSettingList = NotificationSettingList.fromJson(jsonSettingList);
      this.storage.setItem("notification", jsonSettingList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: appColor,
      body: ListView(
        children: [
          _buildDescriptionSection(context),
          _buildNotificationSettingListSection(context, this.notificationSettingList),
        ]
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ), 
      centerTitle: true,
      title: Text(
        settingPageTitle,
        style: TextStyle(color: Colors.black,fontSize: 24.0),
      ),
      backgroundColor: Colors.grey[50],
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => {},
        ),
        IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Personal',
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          settingPageDescription,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildNotificationSettingListSection(BuildContext context, List<NotificationSetting> notificationSettingList) {
    if(notificationSettingList == null)
    {
      return Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notificationSettingList.length,
      itemBuilder: (context, listViewIndex) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
              initiallyExpanded: notificationSettingList[listViewIndex].value,
              leading: null,
              title: ListTile(
                title: Text(notificationSettingList[listViewIndex].title,),
              ),
              trailing: IgnorePointer(
                child: CupertinoSwitch(
                  value: notificationSettingList[listViewIndex].value, 
                  onChanged: (bool value) {}
                ),
              ),
              onExpansionChanged: (bool value){
                setState(() {
                  notificationSettingList[listViewIndex].value = value; 
                });
                storage.setItem("notification", NotificationSettingList.toJson(this.notificationSettingList));
              },
              children: 
              notificationSettingList[listViewIndex].notificationSettingList == null 
              ? []
              : [
                  _buildCheckbox(context, notificationSettingList[listViewIndex].notificationSettingList, 4, 2.0)
                ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(BuildContext context, List<NotificationSetting> checkboxList, int count, double ratio) {

    return GridView.builder(
      shrinkWrap: true,
      itemCount: checkboxList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        childAspectRatio: ratio,
      ),
      itemBuilder: (context, checkboxIndex) {
        return InkWell(
          onTap: () {
            setState(() {
              checkboxList.forEach((element) { element.value = false; });

              checkboxList[checkboxIndex].value = true;
            }); 
            storage.setItem("notification", NotificationSettingList.toJson(this.notificationSettingList));
          },
          child: IgnorePointer(
            child: Row(
              children:[
                Checkbox(
                  value: checkboxList[checkboxIndex].value, 
                  onChanged: (value) {}, 
                ),
                Text(checkboxList[checkboxIndex].title),
              ]
            ),
          ),
        );
      }
    );
  }
}