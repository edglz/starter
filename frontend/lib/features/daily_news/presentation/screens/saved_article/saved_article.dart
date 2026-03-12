import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/saved_articles/saved_articles_app_bar.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/saved_articles/saved_articles_empty.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

/// Saved articles screen: wires LocalArticleBloc with app bar and saved list/empty state.
class SavedArticles extends StatelessWidget {
  const SavedArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
      child: BlocBuilder<LocalArticleBloc, LocalArticlesState>(
        builder: (context, state) {
          final count =
              state is LocalArticlesDone ? state.articles?.length ?? 0 : 0;
          return Scaffold(
            appBar: SavedArticlesAppBar(count: count),
            body: _Body(state: state),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final LocalArticlesState state;

  @override
  Widget build(BuildContext context) {
    if (state is LocalArticlesLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (state is LocalArticlesDone) {
      final articles = state.articles!;
      if (articles.isEmpty) return const SavedArticlesEmpty();
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          final key = ValueKey('${article.id ?? index}_${article.title}_${article.url}');
          return Dismissible(
            key: key,
            direction: DismissDirection.endToStart,
            background: Container(
                  color: AppDesign.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceXL),
                  child: const Icon(Icons.delete, color: AppDesign.surface),
                ),
            onDismissed: (_) {
              context.read<LocalArticleBloc>().add(RemoveArticle(article));
            },
            child: ArticleWidget(
              article: article,
              isRemovable: false,
              onArticlePressed: (a) => Navigator.pushNamed(
                context,
                '/ArticleDetails',
                arguments: a,
              ),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
