import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_upload_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/get_firebase_articles.dart';

class _MockArticleUploadRepository extends Mock
    implements ArticleUploadRepository {}

void main() {
  group('GetFirebaseArticlesUseCase', () {
    late _MockArticleUploadRepository mockRepository;
    late GetFirebaseArticlesUseCase useCase;

    setUp(() {
      mockRepository = _MockArticleUploadRepository();
      useCase = GetFirebaseArticlesUseCase(mockRepository);
    });

    test('delegates to ArticleUploadRepository.getArticles', () async {
      const expected = DataSuccess<List<ArticleEntity>>([
        ArticleEntity(title: 'From Firebase'),
      ]);

      when(() => mockRepository.getArticles())
          .thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, expected);
      verify(() => mockRepository.getArticles()).called(1);
    });
  });
}

