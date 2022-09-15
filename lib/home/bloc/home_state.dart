import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeEmpty extends HomeState {}

class HomeSearching extends HomeState {
  final List<Suggestion> suggestions;

  const HomeSearching(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class HomeHistory extends HomeState {
  final List<Suggestion> suggestions;

  const HomeHistory(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class HomeLoading extends HomeState {
  final String query;

  const HomeLoading(this.query);

  List<Object> get props => [query];
}

class HomeSuccess extends HomeState {
  final Translation translation;

  const HomeSuccess(this.translation);

  @override
  List<Object> get props => [translation];
}

class HomeError extends HomeState {
  final String error;

  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}
