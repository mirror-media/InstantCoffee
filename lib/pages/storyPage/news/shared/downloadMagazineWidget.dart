import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class DownloadMagazineWidget extends StatefulWidget {
  @override
  _DownloadMagazineWidgetState createState() => _DownloadMagazineWidgetState();
}

class _DownloadMagazineWidgetState extends State<DownloadMagazineWidget> {
  _fetchMemberSubscriptionType() {
    context.read<MemberSubscriptionTypeCubit>().fetchMemberSubscriptionType();
  }

  void _delayNavigator(SubscritionType subscritionType) async{
    await Future.delayed(Duration());
    if(subscritionType != null) {
      RouteGenerator.navigateToMagazine(context, subscritionType);
    } else {
      RouteGenerator.navigateToLogin(
        context, 
        routeName: RouteGenerator.magazine,
        routeArguments: {
          'subscritionType': subscritionType,
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
          SubscritionType subscritionType = state.subscritionType;
          _delayNavigator(subscritionType);
          return _downloadMagazineWidget(width, false);
        }
        
        // state is member subscription type init
        return _downloadMagazineWidget(width, false);
      }
    );
  }

  Widget _downloadMagazineWidget(double width, bool isLoading) {
    return Container(
      color: appColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 26),
        child: Column(
          children: [
            Text(
              '下載鏡週刊電子雜誌',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: RaisedButton(
                color: Colors.white,
                child: Container(
                  width: width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: isLoading
                      ? SpinKitThreeBounce(color: appColor, size: 17,)
                      : Text(
                          '立即下載',
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