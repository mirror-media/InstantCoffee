import 'package:flutter_test/flutter_test.dart';
import 'package:readr_app/blocs/section/cubit.dart';
import 'package:readr_app/blocs/section/states.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/services/section_service.dart';

class SectionTestService implements SectionRepos {
  @override
  Future<List<Section>> fetchSectionList({bool needMenu = true}) async {
    List<Section> result = [];
    return result;
  }
}

void main() {
  late SectionCubit sectionCubit;

  setUp(() {
    sectionCubit = SectionCubit(sectionRepos: SectionTestService());
  });

  group('Section bloc:', () {
    test('initial state is correct', () {
      expect(sectionCubit.state, SectionState.init());
    });

    test('fetch section list', () {
      final expectedResponse = [
        SectionState.loading(),
        SectionState.loaded(sectionList: const []),
      ];

      expectLater(
        sectionCubit.stream,
        emitsInOrder(expectedResponse),
      );

      sectionCubit.fetchSectionList(loadingSectionAds: false);
    });
  });
}
