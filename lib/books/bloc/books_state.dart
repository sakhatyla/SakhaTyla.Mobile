import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

class BooksEmpty extends BooksState {}

class BooksLoading extends BooksState {
  const BooksLoading();

  @override
  List<Object> get props => [];
}

class BooksSuccess extends BooksState {
  final List<Book> books;

  const BooksSuccess(this.books);

  @override
  List<Object> get props => [books];
}

class BooksError extends BooksState {
  final String error;

  const BooksError(this.error);

  @override
  List<Object> get props => [error];
}
