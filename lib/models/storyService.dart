import "package:http/http.dart" as http;
import '../helpers/constants.dart';

class StoryService {
  Future<String> _loadPostAPI(String slug) async {
    String endpoint =
        apiBase + 'posts?where={"slug":"' + slug + '"}&related=full';
    final response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "{'status': 'error', 'message': 'API return error'}";
    }
  }

  Future<String> loadStory(String slug) async {
    String jsonString = await _loadPostAPI(slug);
    return jsonString;
  }
}
