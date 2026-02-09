import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/book_view/bloc/book_view_event.dart';
import 'package:sakhatyla/book_view/bloc/book_view_state.dart';
import 'package:sakhatyla/services/api/api.dart';

class BookViewBloc extends Bloc<BookViewEvent, BookViewState> {
  final ApiClient _api;
  final int _bookId;
  final Map<int, BookPage> _pageCache = {};
  Book? _book;

  BookViewBloc({
    required ApiClient api,
    required int bookId,
  })  : _api = api,
        _bookId = bookId,
        super(BookViewInitial()) {
    on<LoadBook>((event, emit) async {
      emit(BookViewLoadingBook());
      try {
        _book = await _api.getBook(_bookId);
        final firstPage = _book!.firstPage ?? 1;
        
        emit(BookViewBookLoaded(
          book: _book!,
          loadedPages: {},
          currentPageNumber: firstPage,
        ));
        
        // Load the first page
        add(LoadPage(firstPage));
      } catch (e) {
        emit(BookViewError(e.toString()));
      }
    });

    on<LoadPage>((event, emit) async {
      if (_book == null) return;

      try {
        final currentState = state;
        
        // Check if page is already cached
        if (_pageCache.containsKey(event.pageNumber)) {
          if (currentState is BookViewBookLoaded) {
            emit(currentState.copyWith(
              loadedPages: Map.from(_pageCache),
              currentPageNumber: event.pageNumber,
            ));
          }
          return;
        }

        // Load the page
        final page = await _api.getBookPageByNumber(
          id: _book!.id,
          number: event.pageNumber,
        );

        _pageCache[event.pageNumber] = page;

        if (currentState is BookViewBookLoaded) {
          emit(currentState.copyWith(
            loadedPages: Map.from(_pageCache),
            currentPageNumber: event.pageNumber,
          ));
        }

        // Preload adjacent pages
        _preloadAdjacentPages(event.pageNumber);
      } catch (e) {
        emit(BookViewError(e.toString()));
      }
    });

    on<PreloadPage>((event, emit) async {
      if (_book == null) return;

      try {
        // Only preload if not already cached
        if (!_pageCache.containsKey(event.pageNumber)) {
          final page = await _api.getBookPageByNumber(
            id: _book!.id,
            number: event.pageNumber,
          );
          _pageCache[event.pageNumber] = page;
        }
      } catch (e) {
        // Silently fail preloading
      }
    });
  }

  void _preloadAdjacentPages(int currentPage) {
    if (_book == null) return;

    final firstPage = _book!.firstPage ?? 1;
    final lastPage = _book!.lastPage ?? currentPage;

    // Preload next page
    if (currentPage < lastPage) {
      add(PreloadPage(currentPage + 1));
    }

    // Preload previous page
    if (currentPage > firstPage) {
      add(PreloadPage(currentPage - 1));
    }
  }
}
