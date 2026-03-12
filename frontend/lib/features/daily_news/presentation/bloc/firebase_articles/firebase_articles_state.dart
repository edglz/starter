import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class FirebaseArticlesState {}

class FirebaseArticlesLoading extends FirebaseArticlesState {}

class FirebaseArticlesDone extends FirebaseArticlesState {
  final List<ArticleEntity> articles;
  FirebaseArticlesDone(this.articles);
}

class FirebaseArticlesError extends FirebaseArticlesState {}
