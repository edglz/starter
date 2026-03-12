import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// AppBar with back button and optional title. Reusable on detail and saved screens.
class ArticleDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ArticleDetailAppBar({Key? key, this.title, this.onBack}) : super(key: key);

  final String? title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      title: title != null && title!.isNotEmpty
          ? Text(
              title!,
              style: const TextStyle(
                color: AppDesign.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBack ?? () => Navigator.pop(context),
        child: const Icon(Ionicons.chevron_back, color: AppDesign.textPrimary),
      ),
    );
  }
}
