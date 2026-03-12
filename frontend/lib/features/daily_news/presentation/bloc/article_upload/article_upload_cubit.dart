import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/upload_article.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';

import 'article_upload_state.dart';

class ArticleUploadCubit extends Cubit<ArticleUploadState> {
  final UploadArticleUseCase _uploadArticleUseCase;

  ArticleUploadCubit(this._uploadArticleUseCase) : super(ArticleUploadInitial());

  Future<void> uploadArticle(ArticleEntity article, {File? image}) async {
    emit(ArticleUploadLoading());
    try {
      final result = await _uploadArticleUseCase(
        params: UploadArticleParams(article: article, image: image),
      );
      if (result is DataSuccess) {
        emit(ArticleUploadSuccess());
      } else {
        emit(ArticleUploadError(result.error?.message ?? AppStrings.publishErrorFallback));
      }
    } catch (e) {
      emit(ArticleUploadError(e.toString()));
    }
  }
}
