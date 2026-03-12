import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Floating action button used to save the current article from the detail screen.
class ArticleDetailFab extends StatelessWidget {
  const ArticleDetailFab({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onSave,
      child: const Icon(Ionicons.bookmark, color: AppDesign.surface),
    );
  }
}
