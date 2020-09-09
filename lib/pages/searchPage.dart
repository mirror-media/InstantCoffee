import 'package:flutter/material.dart';
import 'package:readr_app/blocs/searchPageBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/widgets/searchWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchPageBloc _searchPageBloc;
  
  @override
  void initState() {
    _searchPageBloc = SearchPageBloc();
    super.initState();
  }

  @override
  void dispose() {
    _searchPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<SectionList>>(
        stream: _searchPageBloc.sectionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                SectionList sectionList = snapshot.data.data;

                return SearchWidget(
                  searchPageBloc: _searchPageBloc,
                  sectionList: sectionList,
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
      title: Text(
        searchPageTitle,
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      backgroundColor: appColor,
    );
  }
}