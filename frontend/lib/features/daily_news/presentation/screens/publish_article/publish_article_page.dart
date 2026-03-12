import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:news_app_clean_architecture/config/theme/app_strings.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/publish_article/publish_article_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/publish_article/success_overlay.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class PublishArticlePage extends StatelessWidget {
  const PublishArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleUploadCubit>(),
      child: const _PublishArticleView(),
    );
  }
}

class _PublishArticleView extends StatefulWidget {
  const _PublishArticleView({Key? key}) : super(key: key);

  @override
  State<_PublishArticleView> createState() => _PublishArticleViewState();
}

class _PublishArticleViewState extends State<_PublishArticleView>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedImage;
  late final AnimationController _buttonAnimController;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _buttonScale = _buttonAnimController;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _buttonAnimController.dispose();
    super.dispose();
  }

  Future<void> _animateButtonPress() async {
    await _buttonAnimController.reverse();
    await _buttonAnimController.forward();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _onPublish(BuildContext context) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.publishMissingTitle)),
      );
      return;
    }
    await _animateButtonPress();
    final content = _contentController.text.trim();
    final article = ArticleEntity(
      title: title,
      content: content.isEmpty ? null : content,
      publishedAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
    );
    if (context.mounted) {
      context.read<ArticleUploadCubit>().uploadArticle(article, image: _selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleUploadCubit, ArticleUploadState>(
      listener: (context, state) async {
        if (state is ArticleUploadSuccess) {
          await _showSuccessOverlay(context);
          if (context.mounted) Navigator.pop(context);
        } else if (state is ArticleUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppDesign.surface,
        appBar: AppBar(
          backgroundColor: AppDesign.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: AppDesign.publishBackIconSize,
              color: AppDesign.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            AppStrings.publishScreenTitle,
            style: TextStyle(
              color: AppDesign.textPrimary,
              fontSize: AppDesign.fontSizeAppBarTitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDesign.publishFormPaddingH),
                  child: Column(
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: AppDesign.publishFormSpacing),
                      _buildImageSection(),
                      const SizedBox(height: AppDesign.publishFormSpacing),
                      Expanded(child: _buildContentField()),
                    ],
                  ),
                ),
              ),
              PublishArticleButton(
                scaleAnimation: _buttonScale,
                onPressed: () => _onPublish(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.surface,
        borderRadius: AppDesign.borderRadiusCard,
        border: Border.all(color: AppDesign.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceXL, vertical: AppDesign.spaceXs),
      child: TextField(
        controller: _titleController,
        maxLines: 3,
        minLines: 2,
        style: AppDesign.inputStyle,
        decoration: const InputDecoration(
          hintText: AppStrings.publishTitleHint,
          hintStyle: AppDesign.inputHintStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_selectedImage != null) {
      return GestureDetector(
        onTap: _pickImage,
        child: ClipRRect(
          borderRadius: AppDesign.borderRadiusCard,
          child: Image.file(
            _selectedImage!,
            height: AppDesign.publishImagePickerHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceSection, vertical: AppDesign.spaceL),
          decoration: BoxDecoration(
            color: AppDesign.primary.withValues(alpha: AppDesign.primaryWithAlpha),
            borderRadius: BorderRadius.circular(AppDesign.radiusPill),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_a_photo_outlined, size: AppDesign.iconM, color: AppDesign.textPrimary),
              SizedBox(width: AppDesign.spaceM),
              Text(
                AppStrings.publishAttachImage,
                style: TextStyle(
                  fontSize: AppDesign.fontSizeInputSmall,
                  color: AppDesign.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.surface,
        borderRadius: AppDesign.borderRadiusCard,
        border: Border.all(color: AppDesign.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceXL, vertical: AppDesign.spaceXs),
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontSize: AppDesign.fontSizeInputSmall, color: AppDesign.textPrimary),
        decoration: const InputDecoration(
          hintText: AppStrings.publishContentHint,
          hintStyle: AppDesign.inputHintStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _showSuccessOverlay(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppDesign.overlayBarrier,
      builder: (_) => const SuccessOverlay(),
    );
    await Future.delayed(const Duration(milliseconds: 1400));
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}
