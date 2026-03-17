import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class Search extends SearchEvent {
  final String query;

  const Search({required this.query});

  @override
  List<Object> get props => [query];
}

class Suggest extends SearchEvent {
  final String query;

  const Suggest({required this.query});

  @override
  List<Object> get props => [query];
}

class ToggleArticle extends SearchEvent {
  final int id;

  const ToggleArticle(this.id);

  @override
  List<Object> get props => [id];
}

class LastQuery extends SearchEvent {
  @override
  List<Object> get props => [];
}

class FavoriteArticleAdded extends SearchEvent {
  final int id;

  const FavoriteArticleAdded(this.id);

  @override
  List<Object> get props => [id];
}

class FavoriteArticleRemoved extends SearchEvent {
  final int id;

  const FavoriteArticleRemoved(this.id);

  @override
  List<Object> get props => [id];
}
