import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/models/on_boarding_position.dart';
import 'package:readr_app/models/on_boarding_hint.dart';
import 'package:readr_app/widgets/hole_painter.dart';
import 'package:readr_app/widgets/inverted_clipper.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvents, OnBoardingState> {
  final LocalStorage _storage = LocalStorage('setting');

  OnBoardingBloc() : super(const OnBoardingState()) {
    on<CheckOnBoarding>(_checkOnBoarding);
    on<GoToNextHint>(_goToNextHint);
    on<CloseOnBoarding>(_closeOnBoarding);
  }

  void _checkOnBoarding(
    CheckOnBoarding event,
    Emitter<OnBoardingState> emit,
  ) async {
    bool isOnBoarding = await getOnBoardingFromStorage();
    if (isOnBoarding) {
      emit(
        const OnBoardingState(isOnBoarding: true),
      );
    }
  }

  void _goToNextHint(
    GoToNextHint event,
    Emitter<OnBoardingState> emit,
  ) async {
    emit(state.copyWith(
      isOnBoarding: state.isOnBoarding,
      status: event.onBoardingStatus,
      onBoardingPosition: event.onBoardingPosition,
    ));
  }

  void _closeOnBoarding(
    CloseOnBoarding event,
    Emitter<OnBoardingState> emit,
  ) async {
    emit(
      const OnBoardingState(isOnBoarding: false),
    );
  }

  Future<bool> getOnBoardingFromStorage() async {
    if (await _storage.ready) {
      if (_storage.getItem("onBoarding") == null) {
        await setOnBoardingToStorage(true);
        return true;
      } else {
        return _storage.getItem("onBoarding")['isOnBoarding'];
      }
    }

    return false;
  }

  Future<void> setOnBoardingToStorage(bool isOnBoarding) async {
    await _storage.setItem('onBoarding', {"isOnBoarding": isOnBoarding});
  }

  Future<void> setOnBoardingClose() async {
    await setOnBoardingToStorage(false);
  }

  Future<OnBoardingPosition> getSizeAndPosition(GlobalKey key) async {
    RenderBox box = key.currentContext!.findRenderObject()! as RenderBox;
    Size size = box.size;
    Offset offset = box.localToGlobal(Offset.zero);

    OnBoardingPosition onBoardingPosition = OnBoardingPosition(
      left: offset.dx,
      top: offset.dy,
      width: size.width,
      height: size.height,
    );

    return onBoardingPosition;
  }

  ClipPath getClipPathOverlay(
      double left, double top, double width, double height) {
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

  CustomPaint getCustomPaintOverlay(BuildContext context, double left,
      double top, double width, double height) {
    return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: HolePainter(
          left: left,
          top: top,
          width: width,
          height: height,
        ));
  }

  Positioned getHint(BuildContext context, double left, double top,
      OnBoardingHint onBoardingHint) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      // set hint to horizontal mid
      left: onBoardingHint.page == (3 - 1) || onBoardingHint.page == (5 - 1)
          ? width / 2 - onBoardingHint.hintText.length / 2 * 16
          : left + onBoardingHint.left,
      top: top + onBoardingHint.top,
      child: Text(
        onBoardingHint.hintText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
