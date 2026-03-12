import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile.dart';

/// Community card: reuses `ArticleWidget` with a configurable width.
/// Single responsibility: display one community article in the horizontal list.
class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.article,
    required this.width,
    required this.onArticlePressed,
  }) : super(key: key);

  final ArticleEntity article;
  final double width;
  final void Function(ArticleEntity article) onArticlePressed;

  /// Uses [content] as description when [description] is empty (for Firebase articles).
  static ArticleEntity withDescriptionFallback(ArticleEntity article) {
    if (article.description != null && article.description!.isNotEmpty) {
      return article;
    }
    final content = (article.content != null && article.content!.isNotEmpty)
        ? article.content!.trim()
        : '';
    return ArticleEntity(
      id: article.id,
      author: article.author,
      title: article.title,
      description: content.isEmpty ? null : content,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      content: article.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final articleToShow = withDescriptionFallback(article);
    return SizedBox(
      width: width,
      child: ArticleWidget(
        article: articleToShow,
        onArticlePressed: onArticlePressed,
      ),
    );
  }
}
