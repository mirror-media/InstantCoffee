import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/listeningWidgetService.dart';

class ListeningWidgetBloc {
  ListeningWidgetService _listeningWidgetService;

  StreamController _listeningWidgetController;

  StreamSink<ApiResponse<Listening>> get listeningWidgetSink => _listeningWidgetController.sink;

  Stream<ApiResponse<Listening>> get listeningWidgetStream => _listeningWidgetController.stream;

  ListeningWidgetBloc(String slug) {
    _listeningWidgetService = ListeningWidgetService();
    _listeningWidgetController = StreamController<ApiResponse<Listening>>();
    fetchListening(slug);
  }

  sinkToAdd(ApiResponse<Listening> value) {
    if (!_listeningWidgetController.isClosed) {
      listeningWidgetSink.add(value);
    }
  }

  fetchListening(String slug) async {
    sinkToAdd(ApiResponse.loading('Fetching listeningWidget page'));

    try {
      Listening listeningWidget = await _listeningWidgetService.fetchListening(slug);

      sinkToAdd(ApiResponse.completed(listeningWidget));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _listeningWidgetController?.close();
  }
}
