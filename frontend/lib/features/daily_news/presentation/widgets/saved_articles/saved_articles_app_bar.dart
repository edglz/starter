import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';

/// App bar for the Saved Articles screen: back button + title.
class SavedArticlesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SavedArticlesAppBar({Key? key, this.onBack, this.count = 0}) : super(key: key);

  final VoidCallback? onBack;
  final int count;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBack ?? () => Navigator.pop(context),
        child: const Icon(Ionicons.chevron_back, color: AppDesign.textPrimary),
      ),
      title: Text(
        count > 0
            ? '${AppStrings.savedArticlesTitle} ($count)'
            : AppStrings.savedArticlesTitle,
        style: const TextStyle(color: AppDesign.textPrimary),
      ),
    );
  }
}
