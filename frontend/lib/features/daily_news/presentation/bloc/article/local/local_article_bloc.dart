import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/use_cases/get_saved_article.dart';
import '../../../../domain/use_cases/remove_article.dart';
import '../../../../domain/use_cases/save_article.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent,LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase
  ) : super(const LocalArticlesLoading()){
    on <GetSavedArticles> (onGetSavedArticles);
    on <RemoveArticle> (onRemoveArticle);
    on <SaveArticle> (onSaveArticle);
  }


  void onGetSavedArticles(GetSavedArticles event,Emitter<LocalArticlesState> emit) async {
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }
  
  void onRemoveArticle(RemoveArticle removeArticle, Emitter<LocalArticlesState> emit) async {
    final articleToRemove = removeArticle.article;
    if (articleToRemove == null) return;
    final currentArticles = state is LocalArticlesDone ? (state as LocalArticlesDone).articles! : <ArticleEntity>[];
    try {
      await _removeArticleUseCase(params: articleToRemove);
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (_) {
      // If the remove use case fails (e.g. null id), optimistically drop it from the in‑memory list
      final toRemove = articleToRemove;
      final filtered = List<ArticleEntity>.from(currentArticles)
        ..removeWhere((a) =>
            (toRemove.id != null && a.id != null && a.id == toRemove.id) ||
            (toRemove.id == null && a.title == toRemove.title && a.url == toRemove.url));
      emit(LocalArticlesDone(filtered));
    }
  }

  void onSaveArticle(SaveArticle saveArticle,Emitter<LocalArticlesState> emit) async {
    await _saveArticleUseCase(params: saveArticle.article);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }
}