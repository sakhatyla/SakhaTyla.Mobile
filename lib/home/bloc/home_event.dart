import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class Search extends HomeEvent {
  final String query;

  const Search({required this.query});

  @override
  List<Object> get props => [query];
}

class Suggest extends HomeEvent {
  final String query;

  const Suggest({required this.query});

  @override
  List<Object> get props => [query];
}

class ToggleArticle extends HomeEvent {
  final int id;

  const ToggleArticle(this.id);

  @override
  List<Object> get props => [id];
}

class LastQuery extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClickFavorite extends HomeEvent {
  final Article article;
  final bool isFavorite;

  const ClickFavorite({
    required this.article,
    required this.isFavorite
  });

  @override
  List<Object> get props => [article];
}
