import 'package:equatable/equatable.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();
}

class LoadBooks extends BooksEvent {
  @override
  List<Object> get props => [];
}
