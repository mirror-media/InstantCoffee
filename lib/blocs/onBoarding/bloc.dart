import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/models/onBoardingHint.dart';
import 'package:readr_app/widgets/holePainter.dart';
import 'package:readr_app/widgets/invertedClipper.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvents, OnBoardingState> {
  LocalStorage _storage = LocalStorage('setting');

  OnBoardingBloc({OnBoardingStatus status}) : super(OnBoardingState()) {
    on<CheckOnBoarding>(_checkOnBoarding);
    on<GoToNextHint>(_goToNextHint);
  }

  void _checkOnBoarding(
    CheckOnBoarding event,
    Emitter<OnBoardingState> emit,
  ) async{
    bool isOnBoarding = await getOnBoardingFromStorage();
    if(isOnBoarding) {
      emit(
        state.copyWith(
          status: OnBoardingStatus.firstPage,
          onBoarding: null,
        )
      );
    }
  }

  void _goToNextHint(
    GoToNextHint event,
    Emitter<OnBoardingState> emit,
  ) async{
    emit(
      state.copyWith(
        status: event.onBoardingStatus,
        onBoarding: event.onBoarding,
      )
    );
  }
  
  Future<bool> getOnBoardingFromStorage() async {
    if(await _storage.ready) {
      if(_storage.getItem("onBoarding") == null) {
        await setOnBoardingToStorage(true);
        return true;
      } else {
        return _storage.getItem("onBoarding")['isOnBoarding'];
      }
    }

    return false;
  }

  Future<void> setOnBoardingToStorage(bool isOnBoarding) async{
    await _storage.setItem('onBoarding', {"isOnBoarding": isOnBoarding});
  }

  Future<void> setOnBoardingClose() async{
    await setOnBoardingToStorage(false);
  }

  Future<OnBoarding> getSizeAndPosition(GlobalKey key) async{
    RenderBox _box = key.currentContext.findRenderObject();
    Size size = _box.size;
    Offset offset = _box.localToGlobal(Offset.zero);
    
    OnBoarding onBoarding = OnBoarding(
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
      // set hint to horizontal mid
      left: onBoardingHint.page == (3-1) || onBoardingHint.page == (5-1)
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
}
