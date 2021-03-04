import 'package:flutter/material.dart';
import 'package:readr_app/blocs/magazineBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/widgets/magazineListWidget.dart';

class MagazinePage extends StatefulWidget {
  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  MagazineBloc _magazineBloc;

  @override
  void initState() {
    _magazineBloc = MagazineBloc();
    super.initState();
  }

  @override
  void dispose() {
    _magazineBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<MagazineList>>(
        stream: _magazineBloc.magazineListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MagazineList magazineList = snapshot.data.data;

            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                if (magazineList == null) {
                  return Container();
                }

                return MagazineListWidget(
                  magazineList: magazineList,
                );
                break;

              case Status.ERROR:
                return Container();
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('下載電子雜誌'),
      backgroundColor: appColor,
    );
  }
}