import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchSuggesting extends SearchState {
  final List<Suggestion> suggestions;

  const SearchSuggesting(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class SearchHistory extends SearchState {
  final List<Suggestion> suggestions;

  const SearchHistory(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading(this.query);

  List<Object> get props => [query];
}

class SearchSuccess extends SearchState {
  final Translation translation;

  const SearchSuccess(this.translation);

  @override
  List<Object> get props => [translation];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object> get props => [error];
}
