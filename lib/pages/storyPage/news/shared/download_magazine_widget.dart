import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';

class DownloadMagazineWidget extends StatefulWidget {
  final bool isMemberContent;

  const DownloadMagazineWidget({this.isMemberContent = false});

  @override
  _DownloadMagazineWidgetState createState() => _DownloadMagazineWidgetState();
}

class _DownloadMagazineWidgetState extends State<DownloadMagazineWidget> {
  _fetchMemberSubscriptionType() {
    context
        .read<MemberSubscriptionTypeCubit>()
        .fetchMemberSubscriptionType(isNavigateToMagazine: true);
  }

  bool _isFreePremiumEnabled() {
    try {
      final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
      return remoteConfigHelper.isFreePremium;
    } catch (e) {
      // RemoteConfig 未初始化時返回 false
      return false;
    }
  }

  bool _isShowSubEnabled() {
    try {
      final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
      return remoteConfigHelper.isShowSub;
    } catch (e) {
      // RemoteConfig 未初始化時返回 false
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // isShowSub 為 false 時，隱藏整個組件
    if (!_isShowSubEnabled()) {
      return const SizedBox.shrink();
    }

    // 如果 isFreePremium 為 true，隱藏整個組件
    if (_isFreePremiumEnabled()) {
      return const SizedBox.shrink();
    }

    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<MemberSubscriptionTypeCubit,
        MemberSubscriptionTypeState>(builder: (context, state) {
      if (state is MemberSubscriptionTypeLoadingState) {
        return _downloadMagazineWidget(width, true);
      } else if (state is MemberSubscriptionTypeLoadedState) {
        return _downloadMagazineWidget(width, false);
      }

      // state is member subscription type init
      return _downloadMagazineWidget(width, false);
    });
  }

  Widget _downloadMagazineWidget(double width, bool isLoading) {
    if (widget.isMemberContent) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            '即時享受所有文章的無限閱讀，零限制探索知識的邊界。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(0, 0, 0, 0.66),
            ),
          ),
          const SizedBox(height: 24),
          AbsorbPointer(
            absorbing: isLoading,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isLoading
                        ? const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 17,
                          )
                        : const Text(
                            '線上閱讀',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                onPressed: () => _fetchMemberSubscriptionType()),
          ),
        ]),
      );
    }
    return Container(
      color: appColor,
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 26),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          const Text(
            '即時新鮮事，精選獨家動態雜誌線上閱讀',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: AbsorbPointer(
              absorbing: isLoading,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: isLoading
                            ? const SpinKitThreeBounce(
                                color: appColor,
                                size: 17,
                              )
                            : const Text(
                                '線上閱讀',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: appColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                  onPressed: () => _fetchMemberSubscriptionType()),
            ),
          ),
        ]),
      ),
    );
  }
}
