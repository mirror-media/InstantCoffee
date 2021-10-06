import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/checkTokenStateBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class DownloadMagazineWidget extends StatefulWidget {
  @override
  _DownloadMagazineWidgetState createState() => _DownloadMagazineWidgetState();
}

class _DownloadMagazineWidgetState extends State<DownloadMagazineWidget> {
  CheckTokenStateBloc _checkTokenStateBloc;
  
  @override
  void initState() {
    _checkTokenStateBloc = CheckTokenStateBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    
    return StreamBuilder<ApiResponse<void>>(
      initialData: ApiResponse.completed(false),
      stream: _checkTokenStateBloc.checkTokenStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return _downloadMagazineWidget(width, true);
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              return _downloadMagazineWidget(width, false);
              break;

            case Status.ERROR:
              return Container();
              break;
          }
        }
        return Container();
      },
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
                    _checkTokenStateBloc.checkTokenState(context);
                  },
              ),
            ),
          ]
        ),
      ),
    );
  }
}