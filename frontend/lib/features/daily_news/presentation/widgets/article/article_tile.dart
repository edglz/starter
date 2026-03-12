import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/utils/date_formatter.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = article?.urlToImage != null && article!.urlToImage!.isNotEmpty;
    final title = article?.title ?? '';
    final description = article?.description ?? '';
    final date = article?.publishedAt ?? '';

    final tile = InkWell(
      onTap: _onTap,
      child: Padding(
          padding: AppDesign.tilePadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppDesign.borderRadiusTile,
                child: SizedBox(
                  width: AppDesign.tileImageSize,
                  height: AppDesign.tileImageSize,
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: article!.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholderBox(),
                          errorWidget: (_, __, ___) => _placeholderBox(),
                        )
                      : _placeholderBox(),
                ),
              ),
              const SizedBox(width: AppDesign.gapImageText),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppDesign.titleStyle,
                    ),
                    const SizedBox(height: AppDesign.spaceM),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppDesign.bodySmallStyle,
                      ),
                    const SizedBox(height: AppDesign.spaceL),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, size: AppDesign.iconXs, color: AppDesign.textHint),
                        const SizedBox(width: AppDesign.spaceS),
                        Expanded(
                          child: Text(
                            formatArticleDate(date),
                            style: AppDesign.captionStyle,
                          ),
                        ),
                        if (isRemovable == true)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _onRemove();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(AppDesign.spaceXs),
                              child: Icon(Icons.remove_circle_outline,
                                  color: AppDesign.error, size: AppDesign.iconL),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: child,
        ),
      ),
      child: tile,
    );
  }

  Widget _placeholderBox() {
    return Container(
      color: AppDesign.placeholder,
      child: const Icon(Icons.image_outlined, color: AppDesign.textHint, size: AppDesign.iconPlaceholder),
    );
  }

  void _onTap() {
    if (onArticlePressed != null && article != null) onArticlePressed!(article!);
  }

  void _onRemove() {
    if (onRemove != null && article != null) onRemove!(article!);
  }
}