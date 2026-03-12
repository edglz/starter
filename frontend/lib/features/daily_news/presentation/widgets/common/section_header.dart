import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Section header used in lists such as Community and Daily News. Single responsibility: render the title.
class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDesign.sectionHeaderPadding,
      child: Text(title, style: AppDesign.sectionHeaderStyle),
    );
  }
}
