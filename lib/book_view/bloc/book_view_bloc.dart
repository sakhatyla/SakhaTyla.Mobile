import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/book_view/bloc/book_view_event.dart';
import 'package:sakhatyla/book_view/bloc/book_view_state.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/error/error.dart';

class BookViewBloc extends Bloc<BookViewEvent, BookViewState> {
  final ApiClient _api;
  final int _bookId;
  final Map<int, BookPage> _pageCache = {};
  Book? _book;
  List<BookLabel>? _labels;

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

        // Load the first page and labels
        add(LoadPage(firstPage));
        add(LoadLabels());
      } catch (err, s) {
        reportError(err, s);
        emit(BookViewError(err.toString()));
      }
    });

    on<LoadLabels>((event, emit) async {
      try {
        final labelsPage = await _api.getBookLabels(
          filter: {'bookId': _bookId},
        );

        _labels = labelsPage.items;

        // Read current state right before emitting to avoid race condition
        final currentState = state;
        if (currentState is BookViewBookLoaded) {
          emit(currentState.copyWith(labels: _labels));
        }
      } catch (err, s) {
        reportError(err, s);
      }
    });

    on<LoadPage>((event, emit) async {
      if (_book == null) return;

      try {
        // Check if page is already cached
        if (_pageCache.containsKey(event.pageNumber)) {
          // Read current state right before emitting
          final currentState = state;
          if (currentState is BookViewBookLoaded) {
            emit(currentState.copyWith(
              loadedPages: Map.from(_pageCache),
              currentPageNumber: event.pageNumber,
            ));
          }
          // Preload adjacent pages even when serving from cache
          _preloadAdjacentPages(event.pageNumber);
          return;
        }

        // Load the page
        final page = await _api.getBookPageByNumber(
          id: _book!.id,
          number: event.pageNumber,
        );

        _pageCache[event.pageNumber] = page;

        // Read current state right before emitting to avoid race condition
        final currentState = state;
        if (currentState is BookViewBookLoaded) {
          emit(currentState.copyWith(
            loadedPages: Map.from(_pageCache),
            currentPageNumber: event.pageNumber,
          ));
        }

        // Preload adjacent pages
        _preloadAdjacentPages(event.pageNumber);
      } catch (err, s) {
        reportError(err, s);
        emit(BookViewError(err.toString()));
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
      } catch (err, s) {
        reportError(err, s);
      }
    });

    on<NavigateToLabel>((event, emit) async {
      // Just trigger a page load, the UI will handle the PageController
      add(LoadPage(event.pageNumber));
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
