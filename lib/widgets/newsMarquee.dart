import 'package:flutter/material.dart';

import 'package:readr_app/blocs/newsMarqueeBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/newsMarqueeWidget.dart';

class NewsMarquee extends StatefulWidget {
  @override
  _NewsMarqueeState createState() => _NewsMarqueeState();
}

class _NewsMarqueeState extends State<NewsMarquee> {
  NewsMarqueeBloc _newsMarqueeBloc = NewsMarqueeBloc();

  @override
  void dispose() {
    _newsMarqueeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<List<Record>>>(
      stream: _newsMarqueeBloc.recordListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Record>? recordList = snapshot.data?.data;

          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container();

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

            case Status.ERROR:
              return Container();
          }
        }
        return Container();
      },
    );
  }
}
