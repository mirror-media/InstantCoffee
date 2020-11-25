import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';

import 'package:readr_app/helpers/firebaseMessangingHelper.dart';
import 'package:readr_app/models/notificationSetting.dart';
import 'package:readr_app/models/notificationSettingList.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/onBoarding.dart';

class NotificationSettingsPage extends StatefulWidget {
  final OnBoardingBloc onBoardingBloc;
  NotificationSettingsPage({
    @required this.onBoardingBloc,
  });

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  List<GlobalKey> _notificationKeys;
  final LocalStorage _storage = LocalStorage('setting');
  FirebaseMessangingHelper _firebaseMessangingHelper = FirebaseMessangingHelper();
  NotificationSettingList _notificationSettingList = NotificationSettingList();

  @override
  void initState() {
    _notificationKeys = List<GlobalKey>();
    _setNotificationSettingList();
    super.initState();
  }

  _setNotificationSettingList() async {
    if (await _storage.ready) {
      _notificationSettingList =
          NotificationSettingList.fromJson(_storage.getItem("notification"));
    }

    if (_notificationSettingList == null) {
      await _initNotification();
    }

    for(int i=0; i<_notificationSettingList.length; i++) {
      _notificationKeys.add(GlobalKey());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{  
      if(widget.onBoardingBloc.isOnBoarding && 
      widget.onBoardingBloc.status == OnBoardingStatus.FourthPage) {
        // await navigation completed, or onBoarding will get the wrong position
        await Future.delayed(Duration(milliseconds: 300));
        OnBoarding onBoarding = await widget.onBoardingBloc.getSizeAndPosition(_notificationKeys[1]);
        onBoarding.left = 0;
        onBoarding.height += 16;
        onBoarding.isNeedInkWell = true;
        onBoarding.function = () {
          _notificationSettingList[1].value = true;
          _storage.setItem(
              "notification", _notificationSettingList.toJson());

          _firebaseMessangingHelper.subscribeTheNotification(_notificationSettingList[1]);
          widget.onBoardingBloc.closeOnBoarding();
        };

        widget.onBoardingBloc.checkOnBoarding(onBoarding);
        widget.onBoardingBloc.status = OnBoardingStatus.NULL;
      }
    });
    setState(() {});
  }

  Future<void> _initNotification() async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    _notificationSettingList =
        NotificationSettingList.fromJson(jsonSettingList);
    _storage.setItem("notification", jsonSettingList);

    // reset all of topics by defaultNotificationList.json
    _notificationSettingList.forEach(
      (notificationSetting) { 
        _firebaseMessangingHelper.subscribeTheNotification(notificationSetting);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OnBoarding>(
      initialData: OnBoarding(isOnBoarding: false),
      stream: widget.onBoardingBloc.onBoardingStream,
      builder: (context, snapshot) {
        OnBoarding onBoarding = snapshot.data;
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Scaffold(
                appBar: _buildBar(context),
                body: ListView(children: [
                  _buildDescriptionSection(context),
                  _buildNotificationSettingListSection(context, _notificationSettingList),
                ]),
              ),
              if(onBoarding.isOnBoarding)
                widget.onBoardingBloc.getClipPathOverlay(
                  onBoarding.left,
                  onBoarding.top,
                  onBoarding.width,
                  onBoarding.height,
                ),
                if(onBoarding.isOnBoarding && 
                onBoarding.isNeedInkWell)
                  GestureDetector(
                    onTap: () async{
                      onBoarding.function?.call();
                    },
                    child: widget.onBoardingBloc.getCustomPaintOverlay(
                      context,
                      onBoarding.left,
                      onBoarding.top,
                      onBoarding.width,
                      onBoarding.height,
                    ),
                  ),
              if(onBoarding.isOnBoarding)
                widget.onBoardingBloc.getHint(
                  context,
                  onBoarding.left, 
                  onBoarding.top + onBoarding.height,
                  widget.onBoardingBloc.onBoardingHintList[widget.onBoardingBloc.status.index-1],
                ),
            ],
          ),
        );
      },
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
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      backgroundColor: appColor,
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
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notificationSettingList.length,
      itemBuilder: (context, listViewIndex) {
        return Padding(
          key: _notificationKeys[listViewIndex],
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
              initiallyExpanded: notificationSettingList[listViewIndex].value,
              leading: null,
              title: ListTile(
                title: Text(
                  notificationSettingList[listViewIndex].title,
                  style: TextStyle(
                    color:  Colors.black,
                  ),
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

                _firebaseMessangingHelper.subscribeTheNotification(notificationSettingList[listViewIndex]);
                widget.onBoardingBloc.closeOnBoarding();
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

              _firebaseMessangingHelper.subscribeTheNotification(checkboxList[checkboxIndex]);
            },
            child: IgnorePointer(
              child: Row(children: [
                Checkbox(
                  value: checkboxList[checkboxIndex].value,
                  onChanged: (value) {},
                ),
                Expanded(child: Text(checkboxList[checkboxIndex].title)),
              ]),
            ),
          );
        });
  }
}