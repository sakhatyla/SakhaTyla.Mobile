import 'package:equatable/equatable.dart';
import 'package:sakhatyla/models/translation.dart';

abstract class SearchResultState extends Equatable {
  const SearchResultState();

  @override
  List<Object> get props => [];
}

class SearchResultEmpty extends SearchResultState {}

class SearchResultLoading extends SearchResultState {}

class SearchResultSuccess extends SearchResultState {
  final Translation translation;

  const SearchResultSuccess(this.translation);

  @override
  List<Object> get props => [translation];
}

class SearchResultError extends SearchResultState {
  final String error;

  const SearchResultError(this.error);

  @override
  List<Object> get props => [error];
}
