import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class JoinMemberBlock extends StatelessWidget {
  final bool isMember;
  final String storySlug;
  final bool isMemberContent;
  JoinMemberBlock({ 
    required this.isMember,
    required this.storySlug,
    this.isMemberContent = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; 
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
        child: Column(
          children: [
            Text(
              '歡迎加入鏡週刊',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: appColor,
              ),
            ),
            Text(
              '會員專區',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: appColor,
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: appColor),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    '限時優惠每月\$50元',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '全站看到飽',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: appColor,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                    ),
                    child: Container(
                      width: width,
                      child: Center(
                        child: Text(
                          isMember ? '成為 Premium 會員' : '加入 Premium 會員',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if(isMember) {
                        RouteGenerator.navigateToSubscriptionSelect(
                          storySlug: storySlug,
                        );
                      } else {
                        RouteGenerator.navigateToLogin(
                          routeName: RouteGenerator.story,
                          routeArguments: {
                            'slug': storySlug,
                            'isMemberCheck': true,
                            'isMemberContent': isMemberContent,
                          },
                        );
                      }
                    }
                  ),
                ],
              ),
            ),
            if(!isMember)...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Text(
                      '立即登入',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => RouteGenerator.navigateToLogin(
                      routeName: RouteGenerator.story,
                      routeArguments: {
                        'slug': storySlug,
                        'isMemberCheck': true,
                        'isMemberContent': isMemberContent,
                      },
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '享專屬優惠',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ]
        ),
      )
    );
  }
}