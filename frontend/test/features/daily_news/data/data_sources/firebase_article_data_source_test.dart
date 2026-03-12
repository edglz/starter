// ignore_for_file: subtype_of_sealed_class

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/firebase_articles_cache.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_article_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionRef extends Mock implements CollectionReference<Map<String, dynamic>> {}

class _MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class _MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

class _MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class _MockStorage extends Mock implements FirebaseStorage {}

class _MockAuth extends Mock implements FirebaseAuth {}

class _MockUserCredential extends Mock implements UserCredential {}

class _MockUser extends Mock implements User {}

class _MockCache extends Mock implements FirebaseArticlesCache {}

void main() {
  setUpAll(() {
    // Fallback necesario para parámetros de tipo File en any()
    registerFallbackValue(File('dummy.jpg'));
  });

  group('FirebaseArticleDataSourceImpl', () {
    late _MockFirestore firestore;
    late _MockStorage storage;
    late _MockAuth auth;
    late _MockCache cache;
    late FirebaseArticleDataSourceImpl dataSource;

    setUp(() {
      firestore = _MockFirestore();
      storage = _MockStorage();
      auth = _MockAuth();
      cache = _MockCache();
      dataSource = FirebaseArticleDataSourceImpl(
        firestore: firestore,
        storage: storage,
        auth: auth,
        cache: cache,
      );
    });

    test('uploadArticle completes when no user is signed in', () async {
      const article = ArticleEntity(title: 'Title');

      final mockUser = _MockUser();
      when(() => mockUser.uid).thenReturn('uid-123');

      final mockCred = _MockUserCredential();
      when(() => mockCred.user).thenReturn(mockUser);

      when(() => auth.currentUser).thenReturn(null);
      when(() => auth.signInAnonymously()).thenAnswer((_) async => mockCred);

      final collection = _MockCollectionRef();
      when(() => firestore.collection('articles')).thenReturn(collection);
      when(() => collection.add(any())).thenAnswer((_) async => _MockDocumentReference());
      // No image passed to avoid dealing with UploadTask Future semantics in the mock.
      await dataSource.uploadArticle(article: article, image: null);
    });

    test('getArticles reads from Firestore, maps to ArticleEntity and writes to cache', () async {
      final collection = _MockCollectionRef();
      final query = _MockQuery();
      final snapshot = _MockQuerySnapshot();
      final doc = _MockQueryDocumentSnapshot();

      when(() => firestore.collection('articles')).thenReturn(collection);
      when(() => collection.orderBy('publishedAt', descending: true)).thenReturn(query);
      when(() => query.limit(20)).thenReturn(query);
      when(() => query.get()).thenAnswer((_) async => snapshot);

      when(() => snapshot.docs).thenReturn([doc]);
      when(() => doc.data()).thenReturn({
        'title': 'Title',
        'author': 'Author',
        'description': 'Desc',
        'url': 'https://example.com',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': Timestamp.now(),
        'content': 'Body',
      });

      when(() => cache.write(any())).thenAnswer((_) async {});

      final result = await dataSource.getArticles();

      expect(result, isNotEmpty);
      verify(() => cache.write(any())).called(1);
    });
  });
}

class _MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

