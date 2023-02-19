import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class Load extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class ToggleArticleFavorite extends FavoriteEvent {
  final Article article;

  const ToggleArticleFavorite(this.article);

  @override
  List<Object> get props => [article];
}
