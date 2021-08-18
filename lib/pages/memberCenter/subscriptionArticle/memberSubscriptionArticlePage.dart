import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';

class MemberSubscriptionArticlePage extends StatefulWidget {
  @override
  _MemberSubscriptionArticlePageState createState() => _MemberSubscriptionArticlePageState();
}

class _MemberSubscriptionArticlePageState extends State<MemberSubscriptionArticlePage> {
  final List<Record> recordList = [
    Record(
      title: '【網紅星勢力】唱歌拉二胡還不夠　許貝貝、小黛比陪聊留人',
      slug: '20191028ent006',
      publishedDate: '2021/05/21',
      photoUrl: 'https://www.mirrormedia.com.tw/assets/images/20210317185015-013b905320686dea9abf085902f36118-mobile.png',
    ),
    Record(
      title: '【一鏡到底】蛤蠣湯改寫的人生　Jason Wang',
      slug: '20210128pol001',
      publishedDate: '2021/03/08',
      photoUrl: 'https://www.mirrormedia.com.tw/assets/images/20201225153902-d356ebd654503ff960caf62a5b55988e-mobile.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: recordList.length == 0
      ? Center(child: Text('無訂閱文章'))
      : ListView.separated(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          itemCount: recordList.length + 1,
          itemBuilder: (context, index) {
            if (index == recordList.length) {
              return Container();
            }

            return _buildListItem(context, recordList[index]);
          },
        ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        '訂閱中的文章',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildListItem(BuildContext context, Record record) {
    var width = MediaQuery.of(context).size.width;
    double imageSize = 30 * (width - 32) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: imageSize,
              width: imageSize,
              imageUrl: record.photoUrl,
              placeholder: (context, url) => Container(
                height: imageSize,
                width: imageSize,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: imageSize,
                width: imageSize,
                color: Colors.grey,
                child: Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '閱讀期限至 ' + record.publishedDate,
                    style: TextStyle(
                      color: appColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => RouteGenerator.navigateToStory(context, record.slug),
    );
  }
}