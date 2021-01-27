import 'package:flutter/material.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/blocs/memberBloc.dart';
import 'package:readr_app/helpers/memberResponse.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  MemberBloc _memberBloc;
  
  @override
  void initState() {
    _memberBloc = MemberBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return StreamBuilder<MemberResponse<UserData>>(
      initialData: MemberResponse.completed(widget.userData),
      stream: _memberBloc.userDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.Complete:
              UserData userData = snapshot.data.data;
              return _memberSection(width, userData, snapshot.data.status);
              break;

            case Status.SavingLoading:
              UserData userData = snapshot.data.data;
              return _memberSection(width, userData, snapshot.data.status);
              break;

            case Status.SavingSuccessfully:
              UserData userData = snapshot.data.data;
              return _memberSection(width, userData, snapshot.data.status);
              break;

            case Status.SavingError:
              UserData userData = snapshot.data.data;
              return _memberSection(width, userData, snapshot.data.status);
              break;
          }
        }
        return Container();
      }
    );
  }

  _memberSection(
    double width, 
    UserData userData,
    Status status
  ) {
    return Container(
      color: Colors.grey[300],
      child: ListView(
        children: [
          Container(
            color: const Color(0xFFEFEFEF),
            child: Column(
              children: [
                if(status != Status.SavingLoading &&
                  status != Status.SavingError &&
                  status != Status.SavingSuccessfully
                )
                  SizedBox(height: 48,),
                if(status == Status.SavingLoading)
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SpinKitThreeBounce(color: Colors.grey[300], size: 36,),
                  ),
                if(status == Status.SavingSuccessfully)...[
                  Container(
                    height: 38,
                    width: width,
                    color: Color(0xFFF7FEFF),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '儲存成功',
                          style: TextStyle(
                            color: Color(0xFF1D9FB8),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
                if(status == Status.SavingError)...[
                  Container(
                    height: 38,
                    width: width,
                    color: Color(0xFFFFF8F9),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '儲存失敗，請再試一次',
                          style: TextStyle(
                            color: Color(0xFFDB1730),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],

                SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.asset('assets/icon/icon.jpg'),
                ),
                SizedBox(height: 16,),
                Center(
                  child: Text(
                    '你好',
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
                    RouteGenerator.navigateToEditUserProfile(
                      context, 
                      userData,
                      _memberBloc,
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
                        '聯絡資訊',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    RouteGenerator.navigateToEditUserContactInfo(
                      context, 
                      userData,
                      _memberBloc,
                    );
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