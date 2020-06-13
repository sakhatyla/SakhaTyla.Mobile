import 'package:equatable/equatable.dart';
import 'package:sakhatyla/models/translation.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeEmpty extends HomeState {}

class HomeLoading extends HomeState {}

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
