import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_detail/image_lightbox.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/utils/date_formatter.dart';

/// Article detail body: title, date, image and description/content.
class ArticleDetailBody extends StatelessWidget {
  const ArticleDetailBody({Key? key, required this.article}) : super(key: key);

  final ArticleEntity? article;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleAndDate(article: article),
          _ArticleImage(url: article?.urlToImage),
          _ArticleDescription(article: article),
        ],
      ),
    );
  }
}

class _TitleAndDate extends StatelessWidget {
  const _TitleAndDate({this.article});

  final ArticleEntity? article;

  @override
  Widget build(BuildContext context) {
    final dateStr = article?.publishedAt;
    final formattedDate =
        dateStr != null && dateStr.isNotEmpty ? formatArticleDate(dateStr) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.detailBodyPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article?.title ?? '',
            style: AppDesign.detailTitleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDesign.spaceL + 2),
          if (formattedDate != null)
            Row(
              children: [
                const Icon(Ionicons.time_outline, size: AppDesign.iconXs),
                const SizedBox(width: AppDesign.spaceXs),
                Text(formattedDate, style: AppDesign.captionStyle),
              ],
            ),
        ],
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({this.url});

  final String? url;

  void _openLightbox(BuildContext context) {
    if (url == null || url!.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (_, __, ___) => ImageLightbox(imageUrl: url!),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = url != null && url!.isNotEmpty;
    return Container(
      width: double.maxFinite,
      height: hasImage ? AppDesign.detailImageHeight : AppDesign.detailImagePlaceholderHeight,
      margin: const EdgeInsets.only(top: AppDesign.spaceL + 2),
      child: hasImage
          ? GestureDetector(
              onTap: () => _openLightbox(context),
              child: CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const _PlaceholderBox(
                  icon: Icons.image_outlined,
                ),
                errorWidget: (_, __, ___) => const _PlaceholderBox(
                  icon: Icons.broken_image_outlined,
                ),
              ),
            )
          : const _PlaceholderBox(icon: Icons.article_outlined),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppDesign.primaryLight,
      child: Icon(icon, color: AppDesign.primary, size: AppDesign.detailPlaceholderIconSize),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({this.article});

  final ArticleEntity? article;

  @override
  Widget build(BuildContext context) {
    final description = article?.description ?? '';
    final content = article?.content ?? '';
    final text = [description, content].where((e) => e.isNotEmpty).join('\n\n');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.detailDescriptionPaddingH, vertical: AppDesign.detailDescriptionPaddingV),
      child: Text(text.isEmpty ? '' : text, style: AppDesign.bodyStyle),
    );
  }
}
