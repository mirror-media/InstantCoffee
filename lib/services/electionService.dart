import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/models/election/municipality.dart';

abstract class ElectionRepos {
  Future<Map<String, dynamic>> fetchMunicipalityData();
}

class ElectionService implements ElectionRepos {
  ApiBaseHelper _helper = ApiBaseHelper();
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

  @override
  Future<Map<String, dynamic>> fetchMunicipalityData() async {
    var jsonResponse = await _helper.getByCacheAndAutoCache(
      _remoteConfigHelper.electionApi,
      maxAge: const Duration(minutes: 2),
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
