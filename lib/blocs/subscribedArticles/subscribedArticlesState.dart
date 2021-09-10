part of 'subscribedArticlesCubit.dart';

@immutable
abstract class SubscribedarticlesState {}

class SubscribedarticlesInitial extends SubscribedarticlesState {}

class SubscribedArticlesLoaded extends SubscribedarticlesState {
  final List<SubscribedArticle> subscribedArticles;
  SubscribedArticlesLoaded({this.subscribedArticles});
}

class SubscribedArticlesError extends SubscribedarticlesState {
  final error;
  SubscribedArticlesError({this.error});
}
