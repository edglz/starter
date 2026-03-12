import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class ArticleUploadRepository {
  Future<DataState<void>> uploadArticle({
    required ArticleEntity article,
    File? image,
  });

  Future<DataState<List<ArticleEntity>>> getArticles();
  Future<List<ArticleEntity>> getCachedArticles();
  Stream<List<ArticleEntity>> watchArticles();
}
