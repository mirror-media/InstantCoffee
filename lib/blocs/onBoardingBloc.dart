import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/models/onBoardingHint.dart';
import 'package:readr_app/widgets/holePainter.dart';
import 'package:readr_app/widgets/invertedClipper.dart';

enum OnBoardingStatus { FirstPage, SecondPage, ThirdPage, FourthPage, NULL }

class OnBoardingBloc {
  LocalStorage _storage;

  List<OnBoardingHint> onBoardingHintList;
  OnBoardingStatus status;
  bool isNeedInkWell;
  bool _isOnBoarding;
  bool get isOnBoarding => _isOnBoarding;

  StreamController _onBoardingController;
  StreamSink<OnBoarding> get onBoardingSink =>
      _onBoardingController.sink;
  Stream<OnBoarding> get onBoardingStream =>
      _onBoardingController.stream;

  OnBoardingBloc() {
    onBoardingHintList = List<OnBoardingHint>();
    status = OnBoardingStatus.FirstPage;
    isNeedInkWell = false;
    _storage = LocalStorage('setting');
    _onBoardingController = StreamController<OnBoarding>.broadcast();
  }

  sinkToAdd(OnBoarding value) {
    if (!_onBoardingController.isClosed) {
      onBoardingSink.add(value);
    }
  }

  setOnBoardingHintList() {
    onBoardingHintList.add(
      OnBoardingHint(
        page: 1,
        hintText: '新功能上線！來看看你的個人專屬頁面',
        left: -32,
        top: 16,
      )
    );
    onBoardingHintList.add(
      OnBoardingHint(
        page: 2,
        hintText: '可新增或移除訂閱的文章類別',
        left: 0,
        top: 16,
      )
    );
    onBoardingHintList.add(
      OnBoardingHint(
        page: 3,
        hintText: '最後設定想接收的推播類型',
        left: 64,
        top: 32,
      )
    );
    onBoardingHintList.add(
      OnBoardingHint(
        page: 4,
        hintText: '開啟通知',
        left: 0,
        top: 16,
      )
    );
  }

  Future<void> setOnBoardingFromStorage() async {
    if(_isOnBoarding == null && await _storage.ready) {
      if(_storage.getItem("onBoarding") == null) {
        _isOnBoarding = true;
        _storage.setItem('onBoarding', {"isOnBoarding": true});
      } else {
        _isOnBoarding = _storage.getItem("onBoarding")['isOnBoarding'];
      }
    }
  }

  Future<void> setOnBoardingClose() async{
    _isOnBoarding = false;
    _storage.setItem('onBoarding', {"isOnBoarding": false});
  }

  closeOnBoarding() async{
    await setOnBoardingClose();
    OnBoarding onBoarding = OnBoarding(
      isOnBoarding: isOnBoarding,
      left: 0,
      top: 0,
      width: 0,
      height: 0,
    );
    sinkToAdd(onBoarding);
  }

  checkOnBoarding(OnBoarding data) {
    try {
      OnBoarding onBoarding = data;

      sinkToAdd(onBoarding);
    } catch (e) {
      sinkToAdd(OnBoarding(isOnBoarding: false));
      print(e);
    }
  }

  Future<OnBoarding> getSizeAndPosition(GlobalKey key) async{
    await setOnBoardingFromStorage();
    RenderBox _tabBox = key.currentContext.findRenderObject();
    Size size = _tabBox.size;
    Offset offset = _tabBox.localToGlobal(Offset.zero);
    
    OnBoarding onBoarding = OnBoarding(
      isOnBoarding: isOnBoarding,
      left: offset.dx,
      top: offset.dy,
      width: size.width,
      height: size.height,
    );

    return onBoarding;
  }

  ClipPath getClipPathOverlay(double left, double top, double width, double height) {
    return ClipPath(
      clipper: InvertedClipper(
        left: left,
        top: top,
        width: width,
        height: height,
      ),
      child: Container(
        color: Colors.black54,
      ),
    );
  }

  CustomPaint getCustomPaintOverlay(
    BuildContext context, 
    double left, double top, double width, double height) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: HolePainter(
        left: left,
        top: top,
        width: width,
        height: height,
      )
    );
  }

  Positioned getHint(
    BuildContext context, 
    double left, double top, OnBoardingHint onBoardingHint) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      left: onBoardingHint.page == (3-1)
      ? width/2 - onBoardingHint.hintText.length/2*16
      : left + onBoardingHint.left,
      top: top + onBoardingHint.top,
      child: Text(
        onBoardingHint.hintText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  dispose() {
    _onBoardingController?.close();
  }
}
