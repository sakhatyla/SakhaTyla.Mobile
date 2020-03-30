import 'package:sakhatyla/models/article.dart';

class Translation {
  final String query;
  final List<ArticleGroup> articles;
  final List<Article> moreArticles;

  Translation({this.query, this.articles, this.moreArticles});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      query: json['Query'],
      articles: (json['Articles'] as List<dynamic>).map((dynamic a) => ArticleGroup.fromJson(a)).toList(),
      moreArticles: (json['MoreArticles'] as List<dynamic>).map((dynamic a) => Article.fromJson(a)).toList(),
    );
  }
}

class ArticleGroup {
  final String fromLanguageName;
  final String toLanguageName;
  final List<Article> articles;

  ArticleGroup({this.fromLanguageName, this.toLanguageName, this.articles});

  factory ArticleGroup.fromJson(Map<String, dynamic> json) {
    return ArticleGroup(
      fromLanguageName: json['FromLanguageName'],
      toLanguageName: json['ToLanguageName'],
      articles: (json['Articles'] as List<dynamic>).map((dynamic a) => Article.fromJson(a)).toList()
    );
  }
}