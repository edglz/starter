import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_state.dart';

class PublishArticleButton extends StatelessWidget {
  const PublishArticleButton({
    Key? key,
    required this.onPressed,
    required this.scaleAnimation,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleUploadCubit, ArticleUploadState>(
      builder: (context, state) {
        final isLoading = state is ArticleUploadLoading;
        return GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: const BoxDecoration(
                color: AppDesign.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDesign.radiusSheet),
                  topRight: Radius.circular(AppDesign.radiusSheet),
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppDesign.surface),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, color: AppDesign.textPrimary, size: AppDesign.iconL),
                        SizedBox(width: AppDesign.spaceM),
                        Text(
                          AppStrings.publishButtonLabel,
                          style: AppDesign.buttonLabelStyle,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
