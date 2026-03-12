import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_upload_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/get_firebase_articles.dart';

import 'firebase_articles_state.dart';

class FirebaseArticlesCubit extends Cubit<FirebaseArticlesState> {
  final GetFirebaseArticlesUseCase _getFirebaseArticlesUseCase;
  final ArticleUploadRepository _repository;

  StreamSubscription<List<ArticleEntity>>? _subscription;

  FirebaseArticlesCubit(this._getFirebaseArticlesUseCase, this._repository)
      : super(FirebaseArticlesLoading());

  Future<void> getArticles({bool showLoading = false}) async {
    // Set up real-time subscription once.
    _subscription ??= _repository.watchArticles().listen(
      (articles) {
        emit(FirebaseArticlesDone(articles));
      },
      onError: (_) async {
        final cachedNow = await _repository.getCachedArticles();
        if (cachedNow.isEmpty) {
          emit(FirebaseArticlesError());
        }
      },
    );

    // When the user pulls to refresh, force Loading so skeletons are shown.
    if (showLoading) {
      emit(FirebaseArticlesLoading());
    }

    // 1. Show cache immediately for instant feel (only when we are not forcing loading)
    final cached = await _repository.getCachedArticles();
    if (!showLoading) {
      if (cached.isNotEmpty) {
        emit(FirebaseArticlesDone(cached));
      } else {
        emit(FirebaseArticlesLoading());
      }
    }

    // 2. Fetch fresh articles from Firestore
    try {
      final result = await _getFirebaseArticlesUseCase();
      if (result is DataSuccess && result.data != null) {
        emit(FirebaseArticlesDone(result.data!));
      } else if (result is DataFailed && cached.isEmpty) {
        emit(FirebaseArticlesError());
      }
    } catch (_) {
      if (cached.isEmpty) emit(FirebaseArticlesError());
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
