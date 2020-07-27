import 'package:flutter/material.dart';

import 'package:readr_app/blocs/newsMarqueeBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/newsMarqueeWidget.dart';

class NewsMarquee extends StatefulWidget {
  @override
  _NewsMarqueeState createState() => _NewsMarqueeState();
}

class _NewsMarqueeState extends State<NewsMarquee> {
  NewsMarqueeBloc _newsMarqueeBloc;

  @override
  void initState() {
    _newsMarqueeBloc = NewsMarqueeBloc();
    super.initState();
  }

  @override
  void dispose() {
    _newsMarqueeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<RecordList>>(
      stream: _newsMarqueeBloc.recordListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          RecordList recordList = snapshot.data.data;

          switch (snapshot.data.status) {
            case Status.LOADING:
              return Container();
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              if (recordList == null) {
                return Container();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NewsMarqueeWidget(
                  recordList: recordList,
                ),
              );
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
}
