part of 'subscribedArticlesCubit.dart';

@immutable
abstract class SubscribedArticlesState {}

class SubscribedArticlesInitial extends SubscribedArticlesState {}

class SubscribedArticlesLoaded extends SubscribedArticlesState {
  final List<SubscribedArticle> subscribedArticles;
  SubscribedArticlesLoaded({this.subscribedArticles});
}

class SubscribedArticlesError extends SubscribedArticlesState {
  final error;
  SubscribedArticlesError({this.error});
}
