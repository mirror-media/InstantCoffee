import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/listening.dart';

class ListeningWidgetService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Listening> fetchListening(String youtubeId) async {
    String endpoint = apiBase + 'youtube/videos?part=snippet&maxResults=1&id=' + youtubeId;

    final jsonResponse = await _helper.getByUrl(endpoint);
    Listening listening = Listening.fromJson(jsonResponse["items"][0]['snippet']);
    return listening;
  }
}
