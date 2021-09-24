import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/subscribedArticles/subscribedArticlesCubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/models/subscribedArticle.dart';


class MemberSubscribedArticlePage extends StatefulWidget {
  @override
  _MemberSubscribedArticlePageState createState() => _MemberSubscribedArticlePageState();
}

class _MemberSubscribedArticlePageState extends State<MemberSubscribedArticlePage> {

  @override
  void initState(){
    super.initState();
    _loadSubscribedArticles();
  }

  _loadSubscribedArticles(){
    context.read<SubscribedArticlesCubit>().fetchSubscribedArticles();
  }

  List<SubscribedArticle> subscribedArticles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocBuilder<SubscribedArticlesCubit,SubscribedArticlesState>(
        builder: (context, state){
          if(state is SubscribedArticlesLoaded){
            subscribedArticles = state.subscribedArticles;
            if(subscribedArticles == null || subscribedArticles.length == 0){
              return Center(child: Text('無訂閱文章'));
            }
            else{
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                separatorBuilder: (BuildContext context, int index){
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  );
                },
                itemCount: subscribedArticles.length,
                itemBuilder: (context, index) {
                  return Material(
                    elevation: 1,
                    color: Colors.white,
                    child: _buildListItem(context, subscribedArticles[index]),
                  );
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        }
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

  Widget _buildListItem(BuildContext context, SubscribedArticle subscribedArticle) {
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
                imageUrl: subscribedArticle.photoUrl,
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
                      subscribedArticle.title,
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '閱讀期限至 ' + DateFormat('yyyy/MM/dd').format(subscribedArticle.oneTimeEndDatetime),
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
        onTap: () => RouteGenerator.navigateToStory(context, subscribedArticle.slug),
      );
  }
}