import 'package:flutter_test/flutter_test.dart';
import 'package:readr_app/blocs/newsMarquee/cubit.dart';
import 'package:readr_app/blocs/newsMarquee/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/newsMarqueeService.dart';

class NewsMarqueeTestService implements NewsMarqueeRepos{
  @override
  Future<List<Record>> fetchRecordList() async{
    List<Record> result = [];
    return result;
  }
}

void main() {
  late NewsMarqueeCubit newsMarqueeCubit;

  setUp(() {
    newsMarqueeCubit = NewsMarqueeCubit(newsMarqueeRepos: NewsMarqueeTestService());
  });

  group('News marquee bloc:', () {
    test('initial state is correct', () {
      expect(newsMarqueeCubit.state, NewsMarqueeState.init());
    });

    test('fetch news marquee record list', () {
      final expectedResponse = [
        NewsMarqueeState.loading(),
        NewsMarqueeState.loaded(recordList: []),
      ];

      expectLater(
        newsMarqueeCubit.stream,
        emitsInOrder(expectedResponse),
      );
      
      newsMarqueeCubit.fetchNewsMarqueeRecordList();
    });
  });
}