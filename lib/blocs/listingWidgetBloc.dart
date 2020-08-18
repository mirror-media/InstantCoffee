import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/listing.dart';
import 'package:readr_app/models/listingWidgetService.dart';

class ListingWidgetBloc {
  ListingWidgetService _listingWidgetService;

  StreamController _listingWidgetController;

  StreamSink<ApiResponse<Listing>> get listingWidgetSink => _listingWidgetController.sink;

  Stream<ApiResponse<Listing>> get listingWidgetStream => _listingWidgetController.stream;

  ListingWidgetBloc(String slug) {
    _listingWidgetService = ListingWidgetService();
    _listingWidgetController = StreamController<ApiResponse<Listing>>();
    fetchListing(slug);
  }

  sinkToAdd(ApiResponse<Listing> value) {
    if (!_listingWidgetController.isClosed) {
      listingWidgetSink.add(value);
    }
  }

  fetchListing(String slug) async {
    sinkToAdd(ApiResponse.loading('Fetching listingWidget page'));

    try {
      Listing listingWidget = await _listingWidgetService.fetchListing(slug);

      sinkToAdd(ApiResponse.completed(listingWidget));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _listingWidgetController?.close();
  }
}
