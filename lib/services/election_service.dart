import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/election/municipality.dart';

abstract class ElectionRepos {
  Future<Map<String, dynamic>> fetchMunicipalityData(String api);
}

class ElectionService implements ElectionRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Map<String, dynamic>> fetchMunicipalityData(String api) async {
    var jsonResponse = await _helper.getByCacheAndAutoCache(
      api,
      maxAge: const Duration(seconds: 40),
    );

    List<Municipality> municipalityList = [];
    for (var item in jsonResponse['polling']) {
      municipalityList.add(Municipality.fromJson(item));
    }

    return {
      'lastUpdateTime': DateTime.parse(jsonResponse['updatedAt']),
      'municipalityList': municipalityList,
    };
  }
}
