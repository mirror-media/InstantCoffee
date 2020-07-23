import "package:http/http.dart" as http;
import 'package:readr_app/helpers/constants.dart';

class EditorChoiceService {
  Future<String> _loadEditorChoiceApi() async {
    String endpoint = editorChoiceApi;
    final response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "{'status': 'error', 'message': 'API return error'}";
    }
  }

  Future<String> loadData() async {
    String jsonString = await _loadEditorChoiceApi();
    return jsonString;
  }
}
