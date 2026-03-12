import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Skeleton layout for the article detail screen: title, date, image and body placeholders.
class ArticleDetailSkeleton extends StatelessWidget {
  const ArticleDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppDesign.shimmerBase,
      highlightColor: AppDesign.shimmerHighlight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDesign.detailBodyPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(double.infinity, 22),
                  const SizedBox(height: AppDesign.spaceM),
                  _line(double.infinity, 20),
                  const SizedBox(height: AppDesign.spaceS),
                  _line(180, 20),
                  const SizedBox(height: AppDesign.spaceL + 2),
                  Row(
                    children: [
                      _line(16, 14),
                      const SizedBox(width: AppDesign.spaceXs),
                      _line(120, 14),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDesign.spaceL + 2),
            Container(
              width: double.maxFinite,
              height: AppDesign.detailImageHeight,
              color: AppDesign.surface,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.detailDescriptionPaddingH,
                vertical: AppDesign.detailDescriptionPaddingV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(double.infinity, 14),
                  const SizedBox(height: AppDesign.spaceS),
                  _line(double.infinity, 14),
                  const SizedBox(height: AppDesign.spaceS),
                  _line(280, 14),
                  const SizedBox(height: AppDesign.spaceL),
                  _line(double.infinity, 14),
                  const SizedBox(height: AppDesign.spaceS),
                  _line(double.infinity, 14),
                  const SizedBox(height: AppDesign.spaceS),
                  _line(200, 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(double width, double height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppDesign.surface,
          borderRadius: AppDesign.borderRadiusLine,
        ),
      );
}
