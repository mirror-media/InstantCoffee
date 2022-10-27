import 'dart:math';

import 'package:readr_app/models/election/municipality.dart';

abstract class ElectionRepos {
  Future<Map<String, dynamic>> fetchMunicipalityData();
}

class ElectionService implements ElectionRepos {
  @override
  Future<Map<String, dynamic>> fetchMunicipalityData() async {
    Map<String, dynamic> mockData = {
      'updateTime': '2022-10-24 15:58:16',
      'polling': [
        {
          'city': '台北市',
          'candidate': [
            {
              'candNo': '01',
              'name': '張家豪',
              'party': '台灣動物保護黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '王文娟',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '03',
              'name': '鄭匡宇',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '04',
              'name': '黃聖峰',
              'party': '台澎國際法法理建國黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '05',
              'name': '童文薰',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '06',
              'name': '蔣萬安',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '07',
              'name': '蘇煥智',
              'party': '台灣維新黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '08',
              'name': '黃珊珊',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '09',
              'name': '施奉先',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '10',
              'name': '唐新民',
              'party': '共和黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '11',
              'name': '謝立康',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '12',
              'name': '陳時中',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
        {
          'city': '新北市',
          'candidate': [
            {
              'candNo': '01',
              'name': '林佳龍',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '侯友宜',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
        {
          'city': '桃園市',
          'candidate': [
            {
              'candNo': '01',
              'name': '張善政',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '賴香伶',
              'party': '民眾黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '03',
              'name': '鄭運鵬',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '04',
              'name': '鄭寶清',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
        {
          'city': '台中市',
          'candidate': [
            {
              'candNo': '01',
              'name': '陳美妃',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '蔡其昌',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '03',
              'name': '盧秀燕',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
        {
          'city': '台南市',
          'candidate': [
            {
              'candNo': '01',
              'name': '許忠信',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '林義豐',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '03',
              'name': '謝龍介',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '04',
              'name': '吳炳輝',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '05',
              'name': '黃偉哲',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
        {
          'city': '高雄市',
          'candidate': [
            {
              'candNo': '01',
              'name': '鄭宇翔',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '02',
              'name': '曾尹儷',
              'party': '無黨籍',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '03',
              'name': '柯志恩',
              'party': '國民黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
            {
              'candNo': '04',
              'name': '陳其邁',
              'party': '民進黨',
              'tks': _randomInt(),
              'tksRate': _randomDouble(),
              'elected': _randomBool(),
            },
          ],
        },
      ],
    };

    var jsonResponse = mockData;

    List<Municipality> municipalityList = [];
    for (var item in jsonResponse['polling']) {
      municipalityList.add(Municipality.fromJson(item));
    }

    return {
      'lastUpdateTime': DateTime.parse(jsonResponse['updateTime']),
      'municipalityList': municipalityList,
    };
  }

  int _randomInt() => Random().nextInt(9000000);

  double _randomDouble() => Random().nextDouble() * 70;

  bool _randomBool() => Random().nextBool();
}
