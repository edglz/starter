import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_article_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_upload_repository.dart';

class ArticleUploadRepositoryImpl implements ArticleUploadRepository {
  final FirebaseArticleDataSource _dataSource;

  ArticleUploadRepositoryImpl(this._dataSource);

  @override
  Future<DataState<void>> uploadArticle({
    required ArticleEntity article,
    File? image,
  }) async {
    await _dataSource.uploadArticle(article: article, image: image);
    return const DataSuccess(null);
  }

  @override
  Future<DataState<List<ArticleEntity>>> getArticles() async {
    final articles = await _dataSource.getArticles();
    return DataSuccess(articles);
  }

  @override
  Future<List<ArticleEntity>> getCachedArticles() =>
      _dataSource.getCachedArticles();

  @override
  Stream<List<ArticleEntity>> watchArticles() => _dataSource.watchArticles();
}
