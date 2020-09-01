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

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final String query;
  final Translation translation;

  const HomeSuccess(this.query, this.translation);

  @override
  List<Object> get props => [translation];
}

class HomeError extends HomeState {
  final String error;

  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}
