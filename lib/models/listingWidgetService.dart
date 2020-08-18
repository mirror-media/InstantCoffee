import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/listing.dart';

class ListingWidgetService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Listing> fetchListing(String youtubeId) async {
    String endpoint = apiBase + 'youtube/videos?part=snippet&maxResults=1&id=' + youtubeId;

    final jsonResponse = await _helper.getByUrl(endpoint);
    Listing listing = Listing.fromJson(jsonResponse["items"][0]['snippet']);
    return listing;
  }
}
