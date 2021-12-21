import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/pages/homePage.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  GlobalKey _settingKey = GlobalKey();
  OnBoardingBloc _onBoardingBloc;

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
        OnBoarding onBoarding = state.onBoarding;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              HomePage(
                settingKey: _settingKey,
              ),
              if(onBoarding != null)
                GestureDetector(
                  onTap: () async{
                    if( state.status == OnBoardingStatus.thirdPage) {
                      OnBoarding onBoarding = await _onBoardingBloc.getSizeAndPosition(_settingKey);
                      onBoarding.function = () {
                        RouteGenerator.navigateToNotificationSettings(_onBoardingBloc);
                      };
                      
                      _onBoardingBloc.add(
                        GoToNextHint(
                          onBoardingStatus: OnBoardingStatus.fourthPage,
                          onBoarding: onBoarding,
                        )
                      );
                    } else {
                      onBoarding.function?.call();
                    }
                  },
                  child: _onBoardingBloc.getCustomPaintOverlay(
                    context,
                    onBoarding.left,
                    onBoarding.top,
                    onBoarding.width,
                    onBoarding.height
                  ),
                ),
              // if(onBoarding.isOnBoarding)
              if(onBoarding != null)
                _onBoardingBloc.getHint(
                  context,
                  onBoarding.left, 
                  onBoarding.top + onBoarding.height,
                  state.onBoardingHint
                ),
            ],
          ),
        );
      }
    );
  }
}