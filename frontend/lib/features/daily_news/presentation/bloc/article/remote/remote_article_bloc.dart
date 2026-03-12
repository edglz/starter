import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

const _pageSize = 20;

class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  int _currentPage = 1;

  RemoteArticlesBloc(this._getArticleUseCase) : super(const RemoteArticlesLoading()) {
    on<GetArticles>(_onGetArticles);
    on<LoadMoreArticles>(_onLoadMoreArticles);
  }

  Future<void> _onGetArticles(GetArticles event, Emitter<RemoteArticlesState> emit) async {
    _currentPage = 1;
    emit(const RemoteArticlesLoading());

    final dataState = await _getArticleUseCase(
      params: GetArticleParams(page: _currentPage, pageSize: _pageSize),
    );

    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteArticlesDone(
        dataState.data!,
        hasReachedMax: dataState.data!.isEmpty,
      ));
    } else if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  Future<void> _onLoadMoreArticles(LoadMoreArticles event, Emitter<RemoteArticlesState> emit) async {
    final current = state;
    if (current is! RemoteArticlesDone) return;
    if (current.isLoadingMore || current.hasReachedMax) return;

    emit(RemoteArticlesDone(current.articles!, isLoadingMore: true));

    _currentPage++;
    final dataState = await _getArticleUseCase(
      params: GetArticleParams(page: _currentPage, pageSize: _pageSize),
    );

    if (dataState is DataSuccess && dataState.data != null) {
      final merged = [...current.articles!, ...dataState.data!];
      emit(RemoteArticlesDone(
        merged,
        hasReachedMax: dataState.data!.isEmpty,
      ));
    } else {
      _currentPage--;
      emit(RemoteArticlesDone(current.articles!));
    }
  }
}