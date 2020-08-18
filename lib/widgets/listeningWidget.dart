import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listeningWidgetBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ListeningWidget extends StatefulWidget {
  final String slug;
  const ListeningWidget({key, @required this.slug}) : super(key: key);

  @override
  _ListeningWidget createState() {
    return _ListeningWidget();
  }
}

class _ListeningWidget extends State<ListeningWidget> {
  ListeningWidgetBloc _listeningWidgetBloc;

  @override
  void initState() {
    _listeningWidgetBloc = ListeningWidgetBloc(widget.slug);
    super.initState();
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width / 16 * 9;

    return StreamBuilder<ApiResponse<Listening>>(
      stream: _listeningWidgetBloc.listeningWidgetStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              Listening listening = snapshot.data.data;

              return ListView(children: [
                YoutubeWidget(
                  width: width,
                  youtubeId: widget.slug,
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0 ,0.0),
                  child: _buildTitleAndDescription(listening),
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

  _buildTitleAndDescription(Listening listening) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Column(
      children: [
        Text(
          listening.title,
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
                  listening.publishedAt, 'yyyy/MM/dd HH:mm:ss'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          listening.description.split('---------------------------------------')[0],
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
