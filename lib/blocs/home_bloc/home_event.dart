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
