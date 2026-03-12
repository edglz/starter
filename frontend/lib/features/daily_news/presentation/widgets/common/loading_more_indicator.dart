import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Loading indicator shown while more articles are being fetched.
class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDesign.loadingMorePaddingV),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppDesign.primary,
        ),
      ),
    );
  }
}
