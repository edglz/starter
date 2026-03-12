import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';

/// Footer shown when the user is fully caught up with the feed.
class CaughtUpFooter extends StatelessWidget {
  const CaughtUpFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesign.caughtUpPaddingV),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDesign.caughtUpLineWidth,
            height: AppDesign.caughtUpLineHeight,
            color: AppDesign.divider,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesign.spaceM),
            child: Text(
              AppStrings.caughtUp,
              style: AppDesign.caughtUpStyle,
            ),
          ),
          Container(
            width: AppDesign.caughtUpLineWidth,
            height: AppDesign.caughtUpLineHeight,
            color: AppDesign.divider,
          ),
        ],
      ),
    );
  }
}
