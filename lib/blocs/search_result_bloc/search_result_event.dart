import 'package:equatable/equatable.dart';

abstract class SearchResultEvent extends Equatable {
  const SearchResultEvent();
}

class Search extends SearchResultEvent {
  final String query;

  const Search({this.query});

  @override
  List<Object> get props => [query];
}
