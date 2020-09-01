import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class Search extends HomeEvent {
  final String query;

  const Search({this.query});

  @override
  List<Object> get props => [query];
}

class Suggest extends HomeEvent {
  final String query;

  const Suggest({this.query});

  @override
  List<Object> get props => [query];
}

class ToggleArtice extends HomeEvent {
  final int id;

  const ToggleArtice(this.id);

  @override
  List<Object> get props => [id];
}
