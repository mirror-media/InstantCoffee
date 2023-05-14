import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/newsMarquee/cubit.dart';
import 'package:readr_app/blocs/newsMarquee/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/news_marquee_service.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/widgets/newsMarquee/news_marquee_widget.dart';

class NewsMarquee extends StatefulWidget {
  @override
  _NewsMarqueeState createState() => _NewsMarqueeState();
}

class _NewsMarqueeState extends State<NewsMarquee> with Logger {
  _fetchMemberSubscriptionType(BuildContext context) {
    context.read<NewsMarqueeCubit>().fetchNewsMarqueeRecordList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          NewsMarqueeCubit(newsMarqueeRepos: NewsMarqueeService()),
      child: BlocBuilder<NewsMarqueeCubit, NewsMarqueeState>(
          builder: (context, state) {
        if (state.status == NewsMarqueeStatus.initial) {
          _fetchMemberSubscriptionType(context);
        } else if (state.status == NewsMarqueeStatus.loaded) {
          List<Record> recordList = state.recordList!;

          return Container(
            color: Colors.white,
            child: NewsMarqueeWidget(
              recordList: recordList,
            ),
          );
        } else if (state.status == NewsMarqueeStatus.error) {
          debugLog('NewsMarquee error: ${state.errorMessages}');
        }

        return Container();
      }),
    );
  }
}
