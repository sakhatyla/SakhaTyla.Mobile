import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/books/bloc/books_event.dart';
import 'package:sakhatyla/books/bloc/books_state.dart';
import 'package:sakhatyla/services/api/api.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final ApiClient _api;

  BooksBloc({
    required ApiClient api,
  })  : _api = api,
        super(BooksEmpty()) {
    on<LoadBooks>((event, emit) async {
      emit(BooksLoading());
      try {
        var booksPage = await _api.getBooks();
        if (booksPage.items.isEmpty) {
          emit(BooksEmpty());
        } else {
          emit(BooksSuccess(booksPage.items));
        }
      } catch (e) {
        emit(BooksError(e.toString()));
      }
    });
  }
}
