// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:mockito/mockito.dart';
// import 'package:readr_app/helpers/environment.dart';
// import 'package:readr_app/models/section.dart';
// import 'package:readr_app/services/section_service.dart';
//
// import 'mock_cache_manager.dart';
// import 'service_test.mocks.dart';
//
// void main() {
//   Environment().initConfig(BuildFlavor.development);
//   group('fetch section list', () {
//     test('returns a section List if the http call completes successfully',
//         () async {
//       final client = MockClient();
//
//       // Use Mockito to return a successful response when it calls the
//       // provided http.Client.
//       when(client.get(Uri.parse(Environment().config.sectionApi),
//               headers: {'Cache-control': 'no-cache'}))
//           .thenAnswer((_) async => http.Response('''
//         {
//           "_items": [
//             {
//               "_id": "key",
//               "name": "name",
//               "title": "title",
//               "sortOrder": 0,
//               "focus": true,
//               "type": "type"
//             }
//           ]
//         }
//         ''', 200));
//
//       SectionService sectionService = SectionService();
//       sectionService.helper.setClient(client);
//       sectionService.helper.setCacheManager(MockCacheManager());
//
//       expect(await sectionService.fetchSectionList(needMenu: false),
//           isA<List<Section>>());
//     });
//   });
// }
