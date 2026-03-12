import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/get_saved_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/remove_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

class _MockGetSavedArticleUseCase extends Mock
    implements GetSavedArticleUseCase {}

class _MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

class _MockRemoveArticleUseCase extends Mock implements RemoveArticleUseCase {}

void main() {
  group('LocalArticleBloc', () {
    late _MockGetSavedArticleUseCase mockGetSaved;
    late _MockSaveArticleUseCase mockSave;
    late _MockRemoveArticleUseCase mockRemove;
    late LocalArticleBloc bloc;

    final articles = [
      const ArticleEntity(id: 1, title: 'Saved 1'),
      const ArticleEntity(id: 2, title: 'Saved 2'),
    ];

    setUp(() {
      mockGetSaved = _MockGetSavedArticleUseCase();
      mockSave = _MockSaveArticleUseCase();
      mockRemove = _MockRemoveArticleUseCase();
      bloc = LocalArticleBloc(mockGetSaved, mockSave, mockRemove);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('emits Done with saved articles when GetSavedArticles is added', () async {
      when(() => mockGetSaved()).thenAnswer((_) async => articles);

      bloc.add(const GetSavedArticles());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<LocalArticlesDone>()
              .having((s) => (s).articles!.length, 'length', 2),
        ]),
      );
    });
  });
}

