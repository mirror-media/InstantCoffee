import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class DownloadMagazineWidget extends StatefulWidget {
  final bool isMemberContent;
  const DownloadMagazineWidget({this.isMemberContent = false});
  @override
  _DownloadMagazineWidgetState createState() => _DownloadMagazineWidgetState();
}

class _DownloadMagazineWidgetState extends State<DownloadMagazineWidget> {
  _fetchMemberSubscriptionType() {
    context.read<MemberSubscriptionTypeCubit>().fetchMemberSubscriptionType();
  }

  void _delayNavigator(SubscriptionType subscriptionType) async{
    await Future.delayed(Duration());
    if(subscriptionType != null) {
      RouteGenerator.navigateToMagazine(subscriptionType);
    } else {
      RouteGenerator.navigateToLogin(
        routeName: RouteGenerator.magazine,
        routeArguments: {
          'subscriptionType': subscriptionType,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<MemberSubscriptionTypeCubit, MemberSubscriptionTypeState>(
      builder: (context, state) {
        if(state is MemberSubscriptionTypeLoadingState) {
          return _downloadMagazineWidget(width, true);
        } else if(state is MemberSubscriptionTypeLoadedState) {
          SubscriptionType subscriptionType = state.subscriptionType;
          _delayNavigator(subscriptionType);
          return _downloadMagazineWidget(width, false);
        }
        
        // state is member subscription type init
        return _downloadMagazineWidget(width, false);
      }
    );
  }

  Widget _downloadMagazineWidget(double width, bool isLoading) {
    if(widget.isMemberContent){
      return Card(
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '月費、年費會員免費線上閱讀動態雜誌',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(0, 0, 0, 0.66),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: appColor,
                ),
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: isLoading
                      ? SpinKitThreeBounce(color: appColor, size: 17,)
                      : Text(
                          '線上閱讀',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                    ),
                  ),
                ),
                onPressed: isLoading
                ? () {}
                : () {
                    _fetchMemberSubscriptionType();
                  },
              ),
            ]
          ),
        ),
      );
    }
    return Container(
      color: appColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 26),
        child: Column(
          children: [
            Text(
              '月費、年費會員免費線上閱讀動態雜誌',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                child: Container(
                  width: width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: isLoading
                      ? SpinKitThreeBounce(color: appColor, size: 17,)
                      : Text(
                          '線上閱讀',
                          style: TextStyle(
                            fontSize: 17,
                            color: appColor,
                          ),
                        ),
                    ),
                  ),
                ),
                onPressed: isLoading
                ? () {}
                : () {
                    _fetchMemberSubscriptionType();
                  },
              ),
            ),
          ]
        ),
      ),
    );
  }
}