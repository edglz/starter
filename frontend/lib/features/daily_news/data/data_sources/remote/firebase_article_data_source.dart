import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/firebase_articles_cache.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class FirebaseArticleDataSource {
  Future<void> uploadArticle({required ArticleEntity article, File? image});
  Future<List<ArticleEntity>> getArticles();
  Future<List<ArticleEntity>> getCachedArticles();
  Stream<List<ArticleEntity>> watchArticles();
}

class FirebaseArticleDataSourceImpl implements FirebaseArticleDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final FirebaseArticlesCache _cache;

  FirebaseArticleDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    FirebaseArticlesCache? cache,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _cache = cache ?? FirebaseArticlesCache();

  @override
  Future<void> uploadArticle({
    required ArticleEntity article,
    File? image,
  }) async {
    final user = await _ensureAuthenticated();

    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image);
    }

    await _firestore.collection('articles').add({
      'title': article.title,
      'authorId': user.uid,
      if (article.author != null) 'author': article.author,
      'publishedAt': Timestamp.now(),
      if (article.description != null) 'description': article.description,
      if (article.content != null) 'content': article.content,
      if (article.url != null) 'url': article.url,
      if (imageUrl != null) 'urlToImage': imageUrl,
    });
  }

  @override
  Future<List<ArticleEntity>> getArticles() async {
    final snapshot = await _firestore
        .collection('articles')
        .orderBy('publishedAt', descending: true)
        .limit(20)
        .get();

    final articles = snapshot.docs.map((doc) {
      final data = doc.data();
      final publishedAt = (data['publishedAt'] as Timestamp?)?.toDate();
      return ArticleEntity(
        author: data['author'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        url: data['url'] as String?,
        urlToImage: data['urlToImage'] as String?,
        publishedAt: publishedAt?.toIso8601String(),
        content: data['content'] as String?,
      );
    }).toList();

    await _cache.write(articles);
    return articles;
  }

  @override
  Future<List<ArticleEntity>> getCachedArticles() => _cache.read();

  @override
  Stream<List<ArticleEntity>> watchArticles() async* {
    final snapshots = _firestore
        .collection('articles')
        .orderBy('publishedAt', descending: true)
        .limit(20)
        .snapshots();

    await for (final snapshot in snapshots) {
      final articles = snapshot.docs.map((doc) {
        final data = doc.data();
        final publishedAt = (data['publishedAt'] as Timestamp?)?.toDate();
        return ArticleEntity(
          author: data['author'] as String?,
          title: data['title'] as String?,
          description: data['description'] as String?,
          url: data['url'] as String?,
          urlToImage: data['urlToImage'] as String?,
          publishedAt: publishedAt?.toIso8601String(),
          content: data['content'] as String?,
        );
      }).toList();

      await _cache.write(articles);
      yield articles;
    }
  }

  Future<User> _ensureAuthenticated() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final result = await _auth.signInAnonymously();
    return result.user!;
  }

  Future<String> _uploadImage(File image) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.path.split(RegExp(r'[/\\]')).last}';
    final ref = _storage.ref('media/articles/$fileName');
    await ref.putFile(image);
    return ref.getDownloadURL();
  }
}
