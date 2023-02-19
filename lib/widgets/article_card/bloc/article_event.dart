import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/models/article.dart';

abstract class ArticleFavoriteEvent extends Equatable {
  const ArticleFavoriteEvent();
}

class InitArticle extends ArticleFavoriteEvent {
  final int id;

  const InitArticle(this.id);

  @override
  List<Object> get props => [id];
}

class ClickArticle extends ArticleFavoriteEvent {
  final Article article;

  const ClickArticle(this.article);

  @override
  List<Object> get props => [article];
}
