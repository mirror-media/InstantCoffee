import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/userData.dart';

class MemberWidget extends StatefulWidget {
  final LoginBloc loginBloc;
  final UserData userData;
  MemberWidget({
    @required this.loginBloc,
    @required this.userData,
  });

  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[300],
      child: ListView(
        children: [
          Container(
            color: const Color(0xFFEFEFEF),
            child: Column(
              children: [
                SizedBox(height: 48,),
                SizedBox(
                  width: 90,
                  height: 90,
                  child: widget.userData?.profilePhoto == null
                  ? Image.asset('assets/icon/icon.jpg')
                  : CachedNetworkImage(imageUrl: widget.userData.profilePhoto),
                ),
                SizedBox(height: 16,),
                Center(
                  child: Text(
                    widget.userData.name ?? widget.userData.email,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 32,),
              ],
            ),
          ),
          SizedBox(height: 36,),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '會員檔案',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 12,),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Container(
                      width: width,
                      child: Text(
                        '個人資料',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    RouteGenerator.navigateToEditUserProfile(context, widget.userData);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),

                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Container(
                      width: width,
                      child: Text(
                        '聯絡資訊',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    RouteGenerator.navigateToEditUserContactInfo(context, widget.userData);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 48,),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Container(
                      width: width,
                      child: Text(
                        '登出',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('登出'),
                          content: Text('是否確定登出？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: Text('確認'),
                                onPressed: () async{
                                  widget.loginBloc.signOut();
                                  Navigator.of(context).pop();
                                }
                            )
                          ],
                        );
                      },
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),

                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Container(
                      width: width,
                      child: Text(
                        '刪除帳號',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}