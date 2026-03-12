import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/firebase_articles/firebase_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/firebase_articles/firebase_articles_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/community/community_card.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile_skeleton.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/common/section_header.dart';

/// Community section: composes header + horizontal list of community articles.
class CommunitySection extends StatelessWidget {
  const CommunitySection({
    Key? key,
    required this.onArticlePressed,
  }) : super(key: key);

  final void Function(ArticleEntity article) onArticlePressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseArticlesCubit, FirebaseArticlesState>(
      builder: (context, state) {
        final showSkeleton = state is FirebaseArticlesLoading;
        final articles =
            state is FirebaseArticlesDone ? state.articles : <ArticleEntity>[];

        if (!showSkeleton && articles.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SectionHeader(title: AppStrings.sectionCommunity),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: showSkeleton ? 3 : articles.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: AppDesign.spaceM),
                child: showSkeleton
                    ? const ArticleTileSkeleton()
                    : CommunityCard(
                        article: articles[index],
                        width: MediaQuery.sizeOf(context).width,
                        onArticlePressed: onArticlePressed,
                      ),
              ),
            ),
            const SizedBox(height: AppDesign.communitySectionBottomGap),
          ],
        );
      },
    );
  }
}
