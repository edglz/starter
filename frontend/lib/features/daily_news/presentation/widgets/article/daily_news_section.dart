import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_list_content.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/common/section_header.dart';

/// Daily News section: composes header + vertical list of remote articles.
class DailyNewsSection extends StatelessWidget {
  const DailyNewsSection({
    Key? key,
    required this.state,
    required this.onArticlePressed,
  }) : super(key: key);

  final RemoteArticlesState state;
  final void Function(ArticleEntity article) onArticlePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: AppStrings.sectionDailyNews),
        ArticleListContent(
          state: state,
          onArticlePressed: onArticlePressed,
        ),
      ],
    );
  }
}
