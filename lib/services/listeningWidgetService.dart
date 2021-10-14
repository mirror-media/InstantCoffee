import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/listening.dart';

class ListeningWidgetService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Listening> fetchListening(String youtubeId) async {
    String endpoint =
        Environment().config.apiBase + 'youtube/videos?part=snippet&maxResults=1&id=' + youtubeId;

    final jsonResponse = await _helper.getByCacheAndAutoCache(endpoint, maxAge: listeningWidgetCacheDuration);
    Listening listening = Listening.fromJson(jsonResponse["items"][0]);
    return listening;
  }
}
