import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article/article_tile_skeleton.dart';

/// Skeleton card for Community: wraps `ArticleTileSkeleton` with an optional custom width.
class CommunityCardSkeleton extends StatelessWidget {
  const CommunityCardSkeleton({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    const skeleton = ArticleTileSkeleton();
    if (width == null) return skeleton;
    return SizedBox(width: width, child: skeleton);
  }
}
