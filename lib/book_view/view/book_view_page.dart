import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/book_view/bloc/book_view_bloc.dart';
import 'package:sakhatyla/book_view/bloc/book_view_event.dart';
import 'package:sakhatyla/book_view/bloc/book_view_state.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/services/api/api.dart';

class BookViewPage extends StatefulWidget {
  final int bookId;

  const BookViewPage({required this.bookId});

  @override
  _BookViewPageState createState() => _BookViewPageState();
}

class _BookViewPageState extends State<BookViewPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookViewBloc(
        api: locator<ApiClient>(),
        bookId: widget.bookId,
      )..add(LoadBook()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: BlocBuilder<BookViewBloc, BookViewState>(
            builder: (context, state) {
              if (state is BookViewBookLoaded) {
                return Text(state.book.name ?? 'Книга');
              }
              return Text('Книга');
            },
          ),
          backgroundColor: Colors.black.withAlpha((0.7 * 255).toInt()),
        ),
        body: BlocBuilder<BookViewBloc, BookViewState>(
          builder: (context, state) {
            if (state is BookViewInitial || state is BookViewLoadingBook) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state is BookViewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Ошибка: ${state.error}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is BookViewBookLoaded) {
              final book = state.book;
              final firstPage = book.firstPage ?? 1;
              final lastPage = book.lastPage ?? firstPage;
              final totalPages = lastPage - firstPage + 1;

              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: totalPages,
                      onPageChanged: (index) {
                        final pageNumber = firstPage + index;
                        context.read<BookViewBloc>().add(LoadPage(pageNumber));
                      },
                      itemBuilder: (context, index) {
                        final pageNumber = firstPage + index;
                        final bookPage = state.loadedPages[pageNumber];

                        if (bookPage == null) {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        return _buildPageImage(bookPage);
                      },
                    ),
                  ),
                  _buildPageIndicator(
                      firstPage, lastPage, state.currentPageNumber),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPageImage(BookPage page) {
    final imageUrl = page.fileName!;

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Не удалось загрузить страницу',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int firstPage, int lastPage, int currentPage) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.7 * 255).toInt()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Страница $currentPage из $lastPage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
