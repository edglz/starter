import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile_skeleton.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/common/caught_up_footer.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/common/loading_more_indicator.dart';

/// Daily News list body that maps `RemoteArticlesState` to concrete widgets:
/// skeletons, article tiles, loading‑more indicator or "caught up" footer.
class ArticleListContent extends StatelessWidget {
  const ArticleListContent({
    Key? key,
    required this.state,
    required this.onArticlePressed,
  }) : super(key: key);

  final RemoteArticlesState state;
  final void Function(ArticleEntity article) onArticlePressed;

  @override
  Widget build(BuildContext context) {
    if (state is RemoteArticlesLoading) {
      return _skeletons();
    }
    if (state is RemoteArticlesDone) {
      final done = state as RemoteArticlesDone;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...done.articles!.map(
            (a) => ArticleWidget(
              article: a,
              onArticlePressed: onArticlePressed,
            ),
          ),
          if (done.isLoadingMore) const LoadingMoreIndicator(),
          if (!done.isLoadingMore && done.hasReachedMax) const CaughtUpFooter(),
          if (!done.isLoadingMore && !done.hasReachedMax) const SizedBox(height: AppDesign.loadingFooterHeight),
        ],
      );
    }
    return const SizedBox(height: AppDesign.loadingFooterHeight);
  }

  Widget _skeletons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (_) => const ArticleTileSkeleton()),
    );
  }
}
