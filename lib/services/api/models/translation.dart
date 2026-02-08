import 'package:sakhatyla/services/api/api.dart';

class Translation {
  final String query;
  final List<ArticleGroup> articles;
  final List<Article> moreArticles;

  Translation(
      {required this.query,
      required this.articles,
      required this.moreArticles});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      query: json['query'] ?? '',
      articles: (json['articles'] as List<dynamic>? ?? [])
          .map((dynamic a) => ArticleGroup.fromJson(a))
          .toList(),
      moreArticles: (json['moreArticles'] as List<dynamic>? ?? [])
          .map((dynamic a) => Article.fromJson(a, collapsed: true))
          .toList(),
    );
  }

  Translation copyWith({
    int? toggleArticleId,
    List<int>? favoriteArticleIds,
    List<int>? notFavoriteArticleIds,
  }) {
    return Translation(
      query: this.query,
      articles: this
          .articles
          .map((g) => g.copyWith(
                toggleArticleId: toggleArticleId,
                favoriteArticleIds: favoriteArticleIds,
                notFavoriteArticleIds: notFavoriteArticleIds,
              ))
          .toList(),
      moreArticles: this
          .moreArticles
          .map((a) => a.copyWith(
                toggleArticleId: toggleArticleId,
                favoriteArticleIds: favoriteArticleIds,
                notFavoriteArticleIds: notFavoriteArticleIds,
              ))
          .toList(),
    );
  }

  List<int> getArticleIds() {
    final ids = List<int>.empty(growable: true);
    for (var group in articles) {
      for (var article in group.articles) {
        ids.add(article.id);
      }
    }
    for (var article in moreArticles) {
      ids.add(article.id);
    }
    return ids;
  }
}

class ArticleGroup {
  final String fromLanguageName;
  final String toLanguageName;
  final List<Article> articles;

  ArticleGroup(
      {required this.fromLanguageName,
      required this.toLanguageName,
      required this.articles});

  factory ArticleGroup.fromJson(Map<String, dynamic> json) {
    return ArticleGroup(
        fromLanguageName: json['fromLanguage']?['name'] ?? '',
        toLanguageName: json['toLanguage']?['name'] ?? '',
        articles: (json['articles'] as List<dynamic>? ?? [])
            .map((dynamic a) => Article.fromJson(a))
            .toList());
  }

  ArticleGroup copyWith({
    int? toggleArticleId,
    List<int>? favoriteArticleIds,
    List<int>? notFavoriteArticleIds,
  }) {
    return ArticleGroup(
      fromLanguageName: this.fromLanguageName,
      toLanguageName: this.toLanguageName,
      articles: this
          .articles
          .map((a) => a.copyWith(
                toggleArticleId: toggleArticleId,
                favoriteArticleIds: favoriteArticleIds,
                notFavoriteArticleIds: notFavoriteArticleIds,
              ))
          .toList(),
    );
  }
}
