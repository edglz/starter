import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

/// App bar for the Daily News screen: app title and entry point to saved articles.
class DailyNewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DailyNewsAppBar({
    Key? key,
    required this.onSavedArticles,
  }) : super(key: key);

  final VoidCallback onSavedArticles;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppDesign.surface,
      elevation: 0,
      title: const Text(
        AppStrings.appTitle,
        style: TextStyle(
          color: AppDesign.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: AppDesign.fontSizeAppBarTitle,
        ),
      ),
      actions: [
        BlocBuilder<LocalArticleBloc, LocalArticlesState>(
          builder: (context, state) {
            final count =
                state is LocalArticlesDone ? state.articles?.length ?? 0 : 0;
            return GestureDetector(
              onTap: onSavedArticles,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 14, left: AppDesign.spaceXs),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.bookmark_border_outlined,
                        color: AppDesign.textPrimary),
                    if (count > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesign.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: AppDesign.surface,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
