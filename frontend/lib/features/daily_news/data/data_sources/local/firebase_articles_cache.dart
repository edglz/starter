import 'dart:convert';

import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseArticlesCache {
  static const _key = 'firebase_articles_cache';

  Future<List<ArticleEntity>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => _fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> write(List<ArticleEntity> articles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(articles.map(_toMap).toList()));
  }

  Map<String, dynamic> _toMap(ArticleEntity e) => {
        'author': e.author,
        'title': e.title,
        'description': e.description,
        'url': e.url,
        'urlToImage': e.urlToImage,
        'publishedAt': e.publishedAt,
        'content': e.content,
      };

  ArticleEntity _fromMap(Map<String, dynamic> m) => ArticleEntity(
        author: m['author'] as String?,
        title: m['title'] as String?,
        description: m['description'] as String?,
        url: m['url'] as String?,
        urlToImage: m['urlToImage'] as String?,
        publishedAt: m['publishedAt'] as String?,
        content: m['content'] as String?,
      );
}
