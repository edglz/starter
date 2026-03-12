import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../../domain/entities/article.dart';

abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioError? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  final bool isLoadingMore;
  final bool hasReachedMax;

  const RemoteArticlesDone(
    List<ArticleEntity> articles, {
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  }) : super(articles: articles);

  @override
  List<Object?> get props => [articles, isLoadingMore, hasReachedMax];
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(DioError error) : super(error: error);
}