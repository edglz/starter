import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_upload_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/use_cases/get_firebase_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/firebase_articles/firebase_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/firebase_articles/firebase_articles_state.dart';

class _MockGetFirebaseArticlesUseCase extends Mock
    implements GetFirebaseArticlesUseCase {}

class _MockArticleUploadRepository extends Mock
    implements ArticleUploadRepository {}

void main() {
  group('FirebaseArticlesCubit', () {
    late _MockGetFirebaseArticlesUseCase mockUseCase;
    late _MockArticleUploadRepository mockRepository;
    late FirebaseArticlesCubit cubit;

    final articles = [
      const ArticleEntity(title: 'A'),
      const ArticleEntity(title: 'B'),
    ];

    setUp(() {
      mockUseCase = _MockGetFirebaseArticlesUseCase();
      mockRepository = _MockArticleUploadRepository();
      when(() => mockRepository.watchArticles())
          .thenAnswer((_) => const Stream.empty());
      cubit = FirebaseArticlesCubit(mockUseCase, mockRepository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is Loading', () {
      expect(cubit.state, isA<FirebaseArticlesLoading>());
    });

    test('uses cache first when available and showLoading=false', () async {
      when(() => mockRepository.getCachedArticles())
          .thenAnswer((_) async => articles);
      when(() => mockUseCase())
          .thenAnswer((_) async => DataSuccess<List<ArticleEntity>>(articles));

      await cubit.getArticles(showLoading: false);

      final state = cubit.state;
      expect(state, isA<FirebaseArticlesDone>());
      final doneState = state as FirebaseArticlesDone;
      expect(doneState.articles.length, 2);
    });

    test('emits Error when there is no cache and use case throws', () async {
      when(() => mockRepository.getCachedArticles())
          .thenAnswer((_) async => <ArticleEntity>[]);
      when(() => mockUseCase()).thenThrow(Exception('network'));

      await cubit.getArticles(showLoading: false);

      expect(cubit.state, isA<FirebaseArticlesError>());
    });

    test('when showLoading=true, starts in Loading and ends in Done on success', () async {
      when(() => mockRepository.getCachedArticles())
          .thenAnswer((_) async => articles);
      when(() => mockUseCase())
          .thenAnswer((_) async => DataSuccess<List<ArticleEntity>>(articles));

      final emittedStates = <FirebaseArticlesState>[];
      final sub = cubit.stream.listen(emittedStates.add);

      await cubit.getArticles(showLoading: true);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await sub.cancel();

      expect(emittedStates.first, isA<FirebaseArticlesLoading>());
      expect(emittedStates.last, isA<FirebaseArticlesDone>());
    });
  });
}

