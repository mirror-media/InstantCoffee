import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:readr_app/models/section.dart';
import 'jsonAndObject.dart';

void main() {
  final List<JsonAndObject<Section>> jsonAndObjectList = [
    JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "_id": "key",
            "name": "name",
            "title": "title",
            "description": "description",
            "sortOrder": 0,
            "focus": true,
            "type": "type"
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: 'description',
        order: 0,
        focus: true,
        type: 'type',
      ),
    ),
    JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "key": "key",
            "name": "name",
            "title": "title",
            "description": "description",
            "sortOrder": 0,
            "focus": true,
            "type": "type"
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: 'description',
        order: 0,
        focus: true,
        type: 'type',
      ),
    ),
    JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "_id": "key",
            "name": "name",
            "title": "title",
            "sortOrder": 0,
            "focus": true,
            "type": "type"
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: '',
        order: 0,
        focus: true,
        type: 'type',
      ),
    ),
    JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "_id": "key",
            "name": "name",
            "title": "title",
            "description": "description",
            "order": 0,
            "focus": true,
            "type": "type"
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: 'description',
        order: 0,
        focus: true,
        type: 'type',
      ),
    ),
   JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "_id": "key",
            "name": "name",
            "title": "title",
            "description": "description",
            "sortOrder": 0,
            "type": "type"
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: 'description',
        order: 0,
        focus: false,
        type: 'type',
      ),
    ),
    JsonAndObject<Section>(
      responseBody: 
          '''
          {
            "_id": "key",
            "name": "name",
            "title": "title",
            "description": "description",
            "sortOrder": 0,
            "focus": true
          }
          ''',
      object: Section(
        key: 'key',
        name: 'name',
        title: 'title',
        description: 'description',
        order: 0,
        focus: true,
        type: 'section',
      ),
    ),
  ];

  group('Section model:', () {
    for(int i=0; i<jsonAndObjectList.length; i++) {
      test('fromJson function (JsonAndObject[$i])', () {
        JsonAndObject<Section> jsonAndObject = jsonAndObjectList[i];
        final body = jsonAndObject.responseBody;
        final json = jsonDecode(body);
        Section section = Section.fromJson(json);
        expect(
          section, 
          jsonAndObject.object
        );
      });
    } 

    test('sectionListFromJson function', () async {
      List<dynamic> jsonList = [];
      List<Section> expectedList = [];
      jsonAndObjectList.forEach(
        (jsonAndObject) { 
          final json = jsonDecode(jsonAndObject.responseBody);
          jsonList.add(json);
          expectedList.add(jsonAndObject.object);
        }
      );

      List<Section> sectionList = Section.sectionListFromJson(jsonList);
      expect(
        sectionList,
        expectedList
      );
    });
  });
}