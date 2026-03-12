import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_upload_repository.dart';

class UploadArticleParams {
  final ArticleEntity article;
  final File? image;

  const UploadArticleParams({required this.article, this.image});
}

class UploadArticleUseCase
    implements UseCase<DataState<void>, UploadArticleParams> {
  final ArticleUploadRepository _repository;

  UploadArticleUseCase(this._repository);

  @override
  Future<DataState<void>> call({UploadArticleParams? params}) {
    return _repository.uploadArticle(
      article: params!.article,
      image: params.image,
    );
  }
}
