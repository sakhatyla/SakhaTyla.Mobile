import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class BookViewState extends Equatable {
  const BookViewState();

  @override
  List<Object> get props => [];
}

class BookViewInitial extends BookViewState {}

class BookViewLoadingBook extends BookViewState {}

class BookViewBookLoaded extends BookViewState {
  final Book book;
  final Map<int, BookPage> loadedPages;
  final int currentPageNumber;
  final List<BookLabel>? labels;

  const BookViewBookLoaded({
    required this.book,
    required this.loadedPages,
    required this.currentPageNumber,
    this.labels,
  });

  @override
  List<Object> get props => [
        book,
        loadedPages,
        currentPageNumber,
        labels ?? [],
      ];

  BookViewBookLoaded copyWith({
    Book? book,
    Map<int, BookPage>? loadedPages,
    int? currentPageNumber,
    List<BookLabel>? labels,
  }) {
    return BookViewBookLoaded(
      book: book ?? this.book,
      loadedPages: loadedPages ?? this.loadedPages,
      currentPageNumber: currentPageNumber ?? this.currentPageNumber,
      labels: labels ?? this.labels,
    );
  }
}

class BookViewError extends BookViewState {
  final String error;

  const BookViewError(this.error);

  @override
  List<Object> get props => [error];
}
