import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';

/// Empty state for the saved articles list.
class SavedArticlesEmpty extends StatelessWidget {
  const SavedArticlesEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_border_outlined,
            size: 64,
            color: AppDesign.textHint,
          ),
          SizedBox(height: AppDesign.spaceM),
          Text(
            AppStrings.savedArticlesEmpty,
            style: TextStyle(
              color: AppDesign.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
