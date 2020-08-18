import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listingWidgetBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/models/listing.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ListingWidget extends StatefulWidget {
  final String slug;
  const ListingWidget({key, @required this.slug}) : super(key: key);

  @override
  _ListingWidget createState() {
    return _ListingWidget();
  }
}

class _ListingWidget extends State<ListingWidget> {
  ListingWidgetBloc _listingWidgetBloc;

  @override
  void initState() {
    _listingWidgetBloc = ListingWidgetBloc(widget.slug);
    super.initState();
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width / 16 * 9;

    return StreamBuilder<ApiResponse<Listing>>(
      stream: _listingWidgetBloc.listingWidgetStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              Listing listing = snapshot.data.data;

              return ListView(children: [
                YoutubeWidget(
                  width: width,
                  youtubeId: widget.slug,
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0 ,0.0),
                  child: _buildTitleAndDescription(listing),
                ),
              ]);
              break;

            case Status.ERROR:
              return Container();
              break;
          }
        }
        return Container();
      },
    );
  }

  _buildTitleAndDescription(Listing listing) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Column(
      children: [
        Text(
          listing.title,
          style: TextStyle(
            fontSize: 28,
            color: appColor,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              dateTimeFormat.changeYoutubeStringToDisplayString(
                  listing.publishedAt, 'yyyy/MM/dd HH:mm:ss'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          listing.description.split('---------------------------------------')[0],
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
