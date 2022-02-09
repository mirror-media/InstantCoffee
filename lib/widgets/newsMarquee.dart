import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/newsMarquee/cubit.dart';
import 'package:readr_app/blocs/newsMarquee/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/newsMarqueeService.dart';
import 'package:readr_app/widgets/newsMarqueeWidget.dart';

class NewsMarquee extends StatefulWidget {
  @override
  _NewsMarqueeState createState() => _NewsMarqueeState();
}

class _NewsMarqueeState extends State<NewsMarquee> {
  _fetchMemberSubscriptionType(BuildContext context) {
    context.read<NewsMarqueeCubit>().fetchNewsMarqueeRecordList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewsMarqueeCubit(newsMarqueeRepos: NewsMarqueeService()),
      child: BlocBuilder<NewsMarqueeCubit, NewsMarqueeState>(
        builder: (context, state) {
          if(state.status == NewsMarqueeStatus.initial) {
            _fetchMemberSubscriptionType(context);
          } else if(state.status == NewsMarqueeStatus.loaded) {
            List<Record> recordList = state.recordList!;
            
            return NewsMarqueeWidget(
              recordList: recordList,
            );
          } else if(state.status == NewsMarqueeStatus.error) {
            print('NewsMarquee error: ${state.errorMessages}');
          }

          return Container();
        }
      ),
    );
  }
}
