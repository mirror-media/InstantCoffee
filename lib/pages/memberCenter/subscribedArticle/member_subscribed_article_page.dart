import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/memberCenter/subscribedArticles/subscribed_articles_cubit.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/subscribed_article.dart';
import 'package:readr_app/pages/memberCenter/shared/state_error_widget.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class MemberSubscribedArticlePage extends StatefulWidget {
  @override
  _MemberSubscribedArticlePageState createState() =>
      _MemberSubscribedArticlePageState();
}

class _MemberSubscribedArticlePageState
    extends State<MemberSubscribedArticlePage> {
  @override
  void initState() {
    super.initState();
    _loadSubscribedArticles();
  }

  _loadSubscribedArticles() {
    context.read<SubscribedArticlesCubit>().fetchSubscribedArticles();
  }

  List<SubscribedArticle> subscribedArticles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocBuilder<SubscribedArticlesCubit, SubscribedArticlesState>(
          builder: (context, state) {
        if (state is SubscribedArticlesLoaded) {
          subscribedArticles = state.subscribedArticles;
          if (subscribedArticles.isEmpty) {
            return const Center(child: Text('無訂閱文章'));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              separatorBuilder: (BuildContext context, int index) {
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
        } else if (state is SubscribedArticlesError) {
          return StateErrorWidget(() => _loadSubscribedArticles());
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        '訂閱中的文章',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildListItem(
      BuildContext context, SubscribedArticle subscribedArticle) {
    var width = MediaQuery.of(context).size.width;
    double imageSize = 30 * (width - 32) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
              height: imageSize,
              width: imageSize,
              imageUrl: subscribedArticle.photoUrl!,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscribedArticle.title!,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '閱讀期限至 ${DateFormat('yyyy/MM/dd').format(subscribedArticle.oneTimeEndDatetime)}',
                    style: const TextStyle(
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
      onTap: () => RouteGenerator.navigateToStory(subscribedArticle.slug!),
    );
  }
}
