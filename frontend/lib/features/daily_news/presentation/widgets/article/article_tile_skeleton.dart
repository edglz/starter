import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Skeleton for a Daily News tile: square image on the left and text lines on the right.
class ArticleTileSkeleton extends StatelessWidget {
  const ArticleTileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppDesign.shimmerBase,
      highlightColor: AppDesign.shimmerHighlight,
      child: Padding(
        padding: AppDesign.tilePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppDesign.borderRadiusTile,
              child: Container(
                width: AppDesign.tileImageSize,
                height: AppDesign.tileImageSize,
                color: AppDesign.surface,
              ),
            ),
            const SizedBox(width: AppDesign.gapImageText),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(double.infinity, 18),
                  const SizedBox(height: AppDesign.spaceS),
                  _box(double.infinity, 18),
                  const SizedBox(height: AppDesign.spaceS),
                  _box(160, 18),
                  const SizedBox(height: AppDesign.spaceM),
                  _box(double.infinity, 14),
                  const SizedBox(height: AppDesign.spaceS),
                  _box(200, 14),
                  const SizedBox(height: AppDesign.spaceL),
                  Row(
                    children: [
                      _box(AppDesign.iconXs, AppDesign.iconXs),
                      const SizedBox(width: AppDesign.spaceS),
                      _box(80, 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double width, double height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppDesign.surface,
          borderRadius: AppDesign.borderRadiusLine,
        ),
      );
}
