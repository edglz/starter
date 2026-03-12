import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_detail/article_detail_app_bar.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_detail/article_detail_body.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_detail/article_detail_fab.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_detail/article_detail_skeleton.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

/// Article detail screen: wires LocalArticleBloc with app bar, body and save FAB.
/// When [article] is null, a loading skeleton ([ArticleDetailSkeleton]) is displayed instead of content.
class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({Key? key, this.article}) : super(key: key);

  final ArticleEntity? article;

  @override
  Widget build(BuildContext context) {
    final showSkeleton = article == null;
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>(),
      child: Scaffold(
        appBar: ArticleDetailAppBar(title: article?.title),
        body: showSkeleton
            ? const ArticleDetailSkeleton()
            : ArticleDetailBody(article: article),
        floatingActionButton: showSkeleton
            ? null
            : Builder(
                builder: (innerContext) => ArticleDetailFab(
                  onSave: () => _onSave(innerContext),
                ),
              ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    if (article == null) return;
    context.read<LocalArticleBloc>().add(SaveArticle(article!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppDesign.textPrimary,
        content: Text('Article saved successfully.'),
      ),
    );
  }
}
