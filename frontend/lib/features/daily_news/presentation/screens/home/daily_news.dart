import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/firebase_articles/firebase_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/community/community_section.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/home/daily_news_app_bar.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/daily_news_section.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FirebaseArticlesCubit>(
          create: (_) => sl<FirebaseArticlesCubit>()..getArticles(),
        ),
        BlocProvider<LocalArticleBloc>(
          create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
        ),
      ],
      child: const _DailyNewsView(),
    );
  }
}

class _DailyNewsView extends StatefulWidget {
  const _DailyNewsView();

  @override
  State<_DailyNewsView> createState() => _DailyNewsViewState();
}

class _DailyNewsViewState extends State<_DailyNewsView>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<RemoteArticlesBloc>().add(const LoadMoreArticles());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppDesign.surface,
          appBar: DailyNewsAppBar(
            onSavedArticles: () =>
                Navigator.pushNamed(context, '/SavedArticles'),
          ),
          body: RefreshIndicator(
            color: AppDesign.primary,
            onRefresh: () async {
              context.read<RemoteArticlesBloc>().add(const GetArticles());
              await context
                  .read<FirebaseArticlesCubit>()
                  .getArticles(showLoading: true);
            },
            child: ListView(
              controller: _scrollController,
              children: [
                CommunitySection(
                  onArticlePressed: (article) => _openArticle(context, article),
                ),
                DailyNewsSection(
                  state: state,
                  onArticlePressed: (article) => _openArticle(context, article),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppDesign.primary,
            elevation: 4,
            onPressed: () => Navigator.pushNamed(context, '/PublishArticle')
                .then((_) => context.read<FirebaseArticlesCubit>().getArticles(showLoading: true)),
            child: const Icon(Icons.add, color: AppDesign.surface),
          ),
        );
      },
    );
  }

  void _openArticle(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
