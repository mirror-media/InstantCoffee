import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/OnBoardingPosition.dart';
import 'package:readr_app/pages/homePage.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  GlobalKey _settingKey = GlobalKey();
  late OnBoardingBloc _onBoardingBloc;

  @override
  void initState() {
    _onBoardingBloc = context.read<OnBoardingBloc>();
    _checkOnBoarding();
    super.initState();
  }

  _checkOnBoarding() {
    _onBoardingBloc.add(
      CheckOnBoarding()
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (BuildContext context, OnBoardingState state) {
        bool isOnBoarding = state.isOnBoarding;
        OnBoardingPosition? onBoardingPosition = state.onBoardingPosition;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              HomePage(
                settingKey: _settingKey,
              ),
              if(isOnBoarding && onBoardingPosition != null)
                GestureDetector(
                  onTap: () async{
                    if( state.status == OnBoardingStatus.secondPage) {
                      OnBoardingPosition onBoardingPosition = await _onBoardingBloc.getSizeAndPosition(_settingKey);
                      onBoardingPosition.function = () {
                        RouteGenerator.navigateToNotificationSettings(_onBoardingBloc);
                      };
                      
                      _onBoardingBloc.add(
                        GoToNextHint(
                          onBoardingStatus: OnBoardingStatus.thirdPage,
                          onBoardingPosition: onBoardingPosition,
                        )
                      );
                    } else {
                      onBoardingPosition.function?.call();
                    }
                  },
                  child: _onBoardingBloc.getCustomPaintOverlay(
                    context,
                    onBoardingPosition.left,
                    onBoardingPosition.top,
                    onBoardingPosition.width,
                    onBoardingPosition.height
                  ),
                ),
              if(isOnBoarding && onBoardingPosition != null)
                _onBoardingBloc.getHint(
                  context,
                  onBoardingPosition.left, 
                  onBoardingPosition.top + onBoardingPosition.height,
                  state.onBoardingHint!
                ),
            ],
          ),
        );
      }
    );
  }
}