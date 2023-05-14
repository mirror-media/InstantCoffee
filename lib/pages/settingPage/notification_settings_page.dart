import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/pages/shared/app_version_widget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/firebase_messaging_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/notification_setting.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/on_boarding_position.dart';
import 'package:readr_app/widgets/app_expansion_tile.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late OnBoardingBloc _onBoardingBloc;
  final List<GlobalKey> _notificationKeys = [];
  final List<GlobalKey<AppExpansionTileState>> _expansionTileKeys = [];
  final LocalStorage _storage = LocalStorage('setting');
  final FirebaseMessangingHelper _firebaseMessangingHelper =
      FirebaseMessangingHelper();
  List<NotificationSetting>? _notificationSettingList;

  @override
  void initState() {
    _onBoardingBloc = context.read<OnBoardingBloc>();

    _setNotificationSettingList();
    super.initState();
  }

  _setNotificationSettingList() async {
    if (await _storage.ready) {
      if (_storage.getItem("notification") != null) {
        _notificationSettingList =
            NotificationSetting.notificationSettingListFromJson(
                _storage.getItem("notification"));
      }
    }

    if (_notificationSettingList == null) {
      await _initNotification();
    } else {
      List<NotificationSetting> notificationSettingListFromAsset =
          await _getNotificationFromAsset();
      checkAndSyncNotificationSettingList(
          notificationSettingListFromAsset, _notificationSettingList);
      _notificationSettingList = notificationSettingListFromAsset;
      _storage.setItem(
        "notification",
        NotificationSetting.toNotificationSettingListJson(
            _notificationSettingList!),
      );
    }

    for (int i = 0; i < _notificationSettingList!.length; i++) {
      _notificationKeys.add(GlobalKey());
      _expansionTileKeys.add(GlobalKey());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_onBoardingBloc.state.status == OnBoardingStatus.thirdPage) {
        // await navigation completed, or onBoarding will get the wrong position
        await Future.delayed(const Duration(milliseconds: 300));
        OnBoardingPosition onBoardingPosition =
            await _onBoardingBloc.getSizeAndPosition(_notificationKeys[1]);
        onBoardingPosition.left = 0;
        onBoardingPosition.height += 16;
        onBoardingPosition.function = () {
          _notificationSettingList![1].value = true;
          _storage.setItem(
            "notification",
            NotificationSetting.toNotificationSettingListJson(
                _notificationSettingList!),
          );

          _firebaseMessangingHelper
              .subscribeTheNotification(_notificationSettingList![1]);
          _expansionTileKeys[1].currentState!.expand();
          _onBoardingBloc.setOnBoardingClose();
          _onBoardingBloc.add(CloseOnBoarding());
        };
        _onBoardingBloc.add(GoToNextHint(
          onBoardingStatus: OnBoardingStatus.fourthPage,
          onBoardingPosition: onBoardingPosition,
        ));
      }
    });
    setState(() {});
  }

  Future<List<NotificationSetting>> _getNotificationFromAsset() async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];
    return NotificationSetting.notificationSettingListFromJson(jsonSettingList);
  }

  /// assetList is from defaultNotificationList.json
  /// userList is from storage notification
  /// change the title and topic from assetList
  /// keep the subscription value from userList
  checkAndSyncNotificationSettingList(List<NotificationSetting>? assetList,
      List<NotificationSetting>? userList) async {
    if (assetList != null) {
      for (var asset in assetList) {
        NotificationSetting? user =
            NotificationSetting.getNotificationSettingListById(
                userList, asset.id);
        if (user != null && user.id == asset.id) {
          if (user.topic != asset.topic && user.value) {
            _firebaseMessangingHelper.unsubscribeFromTopic(user.topic!);
            _firebaseMessangingHelper.subscribeToTopic(asset.topic!);
          }
          asset.value = user.value;

          if (asset.notificationSettingList != null ||
              user.notificationSettingList != null) {
            checkAndSyncNotificationSettingList(
                asset.notificationSettingList!, user.notificationSettingList);
          }
        }
      }
    }

    if (userList != null) {
      for (var user in userList) {
        NotificationSetting? asset =
            NotificationSetting.getNotificationSettingListById(
                assetList, user.id);
        if (asset == null && user.topic != null && user.value) {
          _firebaseMessangingHelper.unsubscribeFromTopic(user.topic!);
        }
      }
    }
  }

  Future<void> _initNotification() async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    _notificationSettingList =
        NotificationSetting.notificationSettingListFromJson(jsonSettingList);
    _storage.setItem("notification", jsonSettingList);

    // reset all of topics by defaultNotificationList.json
    for (var notificationSetting in _notificationSettingList!) {
      _firebaseMessangingHelper.subscribeTheNotification(notificationSetting);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (BuildContext context, OnBoardingState state) {
        bool isOnBoarding = state.isOnBoarding;
        OnBoardingPosition? onBoardingPosition = state.onBoardingPosition;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Scaffold(
                appBar: _buildBar(context),
                body: SafeArea(
                  child: CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                        child: _buildDescriptionSection(context)),
                    SliverToBoxAdapter(
                        child: _buildNotificationSettingListSection(
                            context, _notificationSettingList)),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                              height: 180, child: _contactInfo(width))),
                    ),
                  ]),
                ),
              ),
              if (isOnBoarding && onBoardingPosition != null)
                GestureDetector(
                  onTap: () async {
                    onBoardingPosition.function?.call();
                  },
                  child: _onBoardingBloc.getCustomPaintOverlay(
                    context,
                    onBoardingPosition.left,
                    onBoardingPosition.top,
                    onBoardingPosition.width,
                    onBoardingPosition.height,
                  ),
                ),
              if (isOnBoarding && onBoardingPosition != null)
                _onBoardingBloc.getHint(
                    context,
                    onBoardingPosition.left,
                    onBoardingPosition.top + onBoardingPosition.height,
                    state.onBoardingHint!),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
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
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          settingPageDescription,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildNotificationSettingListSection(BuildContext context,
      List<NotificationSetting>? notificationSettingList) {
    if (notificationSettingList == null) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notificationSettingList.length,
      itemBuilder: (context, listViewIndex) {
        return Padding(
          key: _notificationKeys[listViewIndex],
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            child: AppExpansionTile(
              key: _expansionTileKeys[listViewIndex],
              initiallyExpanded: notificationSettingList[listViewIndex].value,
              title: ListTile(
                title: Text(
                  notificationSettingList[listViewIndex].title,
                  style: const TextStyle(
                    color: Colors.black,
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
                  "notification",
                  NotificationSetting.toNotificationSettingListJson(
                      _notificationSettingList!),
                );

                _firebaseMessangingHelper.subscribeTheNotification(
                    notificationSettingList[listViewIndex]);
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
      return [_buildCheckbox(context, notificationSetting, false, 4, 2.0)];
    } else if (notificationSetting.id == 'subscriptionChannels') {
      return [_buildCheckbox(context, notificationSetting, true, 2, 4)];
    }

    return [];
  }

  Widget _buildCheckbox(
      BuildContext context,
      NotificationSetting notificationSetting,
      bool isRepeatable,
      int count,
      double ratio) {
    List<NotificationSetting> checkboxList =
        notificationSetting.notificationSettingList!;
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                  for (var element in checkboxList) {
                    element.value = false;
                  }
                  checkboxList[checkboxIndex].value = true;
                }
              });

              _storage.setItem(
                "notification",
                NotificationSetting.toNotificationSettingListJson(
                    _notificationSettingList!),
              );

              _firebaseMessangingHelper
                  .subscribeTheNotification(notificationSetting);
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

  Widget _contactInfo(double width) {
    return Wrap(children: [
      const Divider(height: 2),
      const SizedBox(height: 16),
      InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: SizedBox(
              width: width,
              child: const Text(
                '聯絡我們',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: mirrorMediaServiceEmail,
            );

            if (await canLaunchUrlString(emailLaunchUri.toString())) {
              await launchUrlString(emailLaunchUri.toString());
            } else {
              throw 'Could not launch $mirrorMediaServiceEmail';
            }
          }),
      InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: SizedBox(
              width: width,
              child: const Text(
                '隱私條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () async {
            RouteGenerator.navigateToStory('privacy', isMemberCheck: false);
          }),
      InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: SizedBox(
              width: width,
              child: const Text(
                '服務條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () {
            RouteGenerator.navigateToStory('service-rule',
                isMemberCheck: false);
          }),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: AppVersionWidget(),
      ),
    ]);
  }
}
