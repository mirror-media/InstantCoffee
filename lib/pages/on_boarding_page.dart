import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/section/cubit.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/models/on_boarding_position.dart';
import 'package:readr_app/pages/home/default/home_page.dart';
import 'package:readr_app/pages/home/premium/premium_home_page.dart';
import 'package:readr_app/services/section_service.dart';

class OnBoardingPage extends StatefulWidget {
  final bool isPremium;
  const OnBoardingPage({Key? key, required this.isPremium}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final GlobalKey _settingKey = GlobalKey();
  late OnBoardingBloc _onBoardingBloc;

  @override
  void initState() {
    _onBoardingBloc = context.read<OnBoardingBloc>();
    _checkOnBoarding();
    super.initState();
  }

  _checkOnBoarding() {
    _onBoardingBloc.add(CheckOnBoarding());
  }

  @override
  Widget build(BuildContext context) {
    // 支援 Remote Config 動態更新
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, memberState) {
        // 檢查是否為真正的付費會員 (不包含 isFreePremium 邏輯)
        bool isActualPremiumMember = memberState.status == MemberStatus.loaded
            ? memberState.shouldShowPremiumUI
            : widget.isPremium;

        // 檢查 isFreePremium 狀態
        bool isFreePremiumEnabled = false;
        try {
          final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
          isFreePremiumEnabled = remoteConfigHelper.isFreePremium;
        } catch (e) {
          // RemoteConfig 未初始化時跳過
        }

        debugPrint(
            'OnBoardingPage: isActualPremiumMember = $isActualPremiumMember, isFreePremiumEnabled = $isFreePremiumEnabled');

        // 只有真正的付費會員且不是 isFreePremium 模式時才顯示 Premium 首頁
        if (isActualPremiumMember && !isFreePremiumEnabled) {
          return BlocProvider(
            create: (context) => SectionCubit(sectionRepos: SectionService()),
            child: PremiumHomePage(
              settingKey: _settingKey,
            ),
          );
        }

        return BlocBuilder<OnBoardingBloc, OnBoardingState>(
            builder: (BuildContext context, OnBoardingState state) {
          bool isOnBoarding = state.isOnBoarding;
          OnBoardingPosition? onBoardingPosition = state.onBoardingPosition;

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                BlocProvider(
                  create: (context) =>
                      SectionCubit(sectionRepos: SectionService()),
                  child: HomePage(
                    settingKey: _settingKey,
                  ),
                ),
                if (isOnBoarding && onBoardingPosition != null)
                  GestureDetector(
                    onTap: () async {
                      if (state.status == OnBoardingStatus.secondPage) {
                        OnBoardingPosition onBoardingPosition =
                            await _onBoardingBloc
                                .getSizeAndPosition(_settingKey);
                        onBoardingPosition.function = () {
                          RouteGenerator.navigateToNotificationSettings(
                              _onBoardingBloc);
                        };

                        _onBoardingBloc.add(GoToNextHint(
                          onBoardingStatus: OnBoardingStatus.thirdPage,
                          onBoardingPosition: onBoardingPosition,
                        ));
                      } else {
                        onBoardingPosition.function?.call();
                      }
                    },
                    child: _onBoardingBloc.getCustomPaintOverlay(
                        context,
                        onBoardingPosition.left,
                        onBoardingPosition.top,
                        onBoardingPosition.width,
                        onBoardingPosition.height),
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
        });
      },
    );
  }
}
