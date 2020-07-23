import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

import 'package:readr_app/models/notificationSetting.dart';
import 'package:readr_app/models/notificationSettingList.dart';
import 'package:readr_app/helpers/constants.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final LocalStorage _storage = LocalStorage('setting');
  NotificationSettingList _notificationSettingList = NotificationSettingList();

  @override
  void initState() {
    _notificationSettingList =
        NotificationSettingList.fromJson(_storage.getItem("notification"));

    if (_notificationSettingList == null) {
      _initNotification();
    }
    super.initState();
  }

  void _initNotification() async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    setState(() {
      _notificationSettingList =
          NotificationSettingList.fromJson(jsonSettingList);
      _storage.setItem("notification", jsonSettingList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(children: [
        _buildDescriptionSection(context),
        _buildNotificationSettingListSection(context, _notificationSettingList),
      ]),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        settingPageTitle,
        style: TextStyle(color: Colors.black, fontSize: 24.0),
      ),
      backgroundColor: appColor,
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

  Widget _buildNotificationSettingListSection(
      BuildContext context, List<NotificationSetting> notificationSettingList) {
    if (notificationSettingList == null) {
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
                title: Text(
                  notificationSettingList[listViewIndex].title,
                ),
              ),
              trailing: IgnorePointer(
                child: CupertinoSwitch(
                    value: notificationSettingList[listViewIndex].value,
                    onChanged: (bool value) {}),
              ),
              onExpansionChanged: (bool value) {
                setState(() {
                  notificationSettingList[listViewIndex].value = value;
                });
                _storage.setItem(
                    "notification", _notificationSettingList.toJson());
              },
              children: _renderCheckBoxChildren(
                  context, notificationSettingList[listViewIndex]),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _renderCheckBoxChildren(
      BuildContext context, NotificationSetting notificationSetting) {
    if (notificationSetting.id == 'horoscopes') {
      return [
        _buildCheckbox(
            context, notificationSetting.notificationSettingList, false, 4, 2.0)
      ];
    } else if (notificationSetting.id == 'subscriptionChannels') {
      return [
        _buildCheckbox(
            context, notificationSetting.notificationSettingList, true, 2, 4)
      ];
    }

    return [];
  }

  Widget _buildCheckbox(
      BuildContext context,
      List<NotificationSetting> checkboxList,
      bool isRepeatable,
      int count,
      double ratio) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: checkboxList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          childAspectRatio: ratio,
        ),
        itemBuilder: (context, checkboxIndex) {
          return InkWell(
            onTap: () {
              setState(() {
                if (isRepeatable) {
                  checkboxList[checkboxIndex].value =
                      !checkboxList[checkboxIndex].value;
                } else {
                  checkboxList.forEach((element) {
                    element.value = false;
                  });
                  checkboxList[checkboxIndex].value = true;
                }
              });

              _storage.setItem(
                  "notification", _notificationSettingList.toJson());
            },
            child: IgnorePointer(
              child: Row(children: [
                Checkbox(
                  value: checkboxList[checkboxIndex].value,
                  onChanged: (value) {},
                ),
                Text(checkboxList[checkboxIndex].title),
              ]),
            ),
          );
        });
  }
}
