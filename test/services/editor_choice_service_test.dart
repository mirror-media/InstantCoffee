import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/editor_choice_service.dart';

import 'mock_cache_manager.dart';
import 'service_test.mocks.dart';

void main() {
  Environment().initConfig(BuildFlavor.development);
  group('fetch editor choice record list', () {
    test('returns an Record List if the http call completes successfully',
        () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(Environment().config.editorChoiceApi),
              headers: {'Cache-control': 'no-cache'}))
          .thenAnswer((_) async => http.Response('''
        {
          "choices": [
            {
              "title": "title",
              "slug": "slug",
              "publishTime": "19110101",
              "photoUrl": "dummy_url",
              "categories": null,
              "sections": null
            }
          ]
        }
        ''', 200));

      EditorChoiceService editorChoiceService = EditorChoiceService();
      editorChoiceService.helper.setClient(client);
      editorChoiceService.helper.setCacheManager(MockCacheManager());

      expect(await editorChoiceService.fetchRecordList(), isA<List<Record>>());
    });
  });
}
