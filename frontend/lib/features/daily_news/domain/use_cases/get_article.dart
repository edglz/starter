import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class GetArticleParams {
  final int page;
  final int pageSize;
  const GetArticleParams({this.page = 1, this.pageSize = 20});
}

class GetArticleUseCase implements UseCase<DataState<List<ArticleEntity>>, GetArticleParams> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({GetArticleParams? params}) {
    final p = params ?? const GetArticleParams();
    return _articleRepository.getNewsArticles(page: p.page, pageSize: p.pageSize);
  }
}