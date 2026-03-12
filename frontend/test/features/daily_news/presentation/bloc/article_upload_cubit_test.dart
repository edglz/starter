import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/upload_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article_upload/article_upload_state.dart';

class _MockUploadArticleUseCase extends Mock implements UploadArticleUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const UploadArticleParams(article: ArticleEntity(title: 'fallback'), image: null),
    );
  });

  group('ArticleUploadCubit', () {
    late _MockUploadArticleUseCase mockUseCase;
    late ArticleUploadCubit cubit;
    const article = ArticleEntity(title: 'Test title');

    setUp(() {
      mockUseCase = _MockUploadArticleUseCase();
      cubit = ArticleUploadCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('emits [Loading, Success] when upload succeeds', () async {
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess<void>(null));

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ArticleUploadLoading>(),
          isA<ArticleUploadSuccess>(),
        ]),
      );

      await cubit.uploadArticle(article);
    });

    test('emits [Loading, Error] when repository returns DataFailed', () async {
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => DataFailed<void>(DioError(
                requestOptions: RequestOptions(path: '/upload'),
              )));

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ArticleUploadLoading>(),
          isA<ArticleUploadError>(),
        ]),
      );

      await cubit.uploadArticle(article);
    });

    test('emits [Loading, Error] when use case throws', () async {
      when(() => mockUseCase(params: any(named: 'params'))).thenThrow(Exception('failure'));

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ArticleUploadLoading>(),
          isA<ArticleUploadError>(),
        ]),
      );

      await cubit.uploadArticle(article);
    });

    test('forwards optional File to use case', () async {
      final file = File('fake_path.jpg');

      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess<void>(null));

      await cubit.uploadArticle(article, image: file);

      verify(
        () => mockUseCase(
          params: any(
            named: 'params',
            that: isA<UploadArticleParams>().having((p) => p.image, 'image', file),
          ),
        ),
      ).called(1);
    });
  });
}

