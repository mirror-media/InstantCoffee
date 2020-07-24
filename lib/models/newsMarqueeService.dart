import "package:http/http.dart" as http;
import 'package:readr_app/helpers/constants.dart';

class NewsMarqueeService {
  Future<String> _loadNewsMarqueeAPI() async {
    String endpoint = newsMarqueeApi;
    final response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "{'status': 'error', 'message': 'API return error'}";
    }
  }

  Future<String> loadData() async {
    String jsonString = await _loadNewsMarqueeAPI();
    return jsonString;
  }
}
