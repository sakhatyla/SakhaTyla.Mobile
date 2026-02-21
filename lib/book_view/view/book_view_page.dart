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
  double? _sliderValue;

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
      child: BlocConsumer<BookViewBloc, BookViewState>(
        listener: (context, state) {
          if (state is BookViewBookLoaded) {
            final firstPage = state.book.firstPage ?? 1;
            final pageIndex = state.currentPageNumber - firstPage;
            if (_pageController.hasClients &&
                _pageController.page?.round() != pageIndex) {
              _pageController.jumpToPage(pageIndex);
              setState(() {
                _sliderValue = null;
              });
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: _buildTitle(state),
              actions: [
                if (state is BookViewBookLoaded &&
                    state.labels != null &&
                    state.labels!.isNotEmpty)
                  _buildLabelsButton(context, state),
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BookViewState state) {
    if (state is BookViewBookLoaded) {
      return Text(state.book.name ?? 'Книга');
    }
    return Text('Книга');
  }

  Widget _buildLabelsButton(BuildContext context, BookViewBookLoaded state) {
    return IconButton(
      icon: Icon(Icons.bookmark),
      onPressed: () => _showLabelsMenu(context, state),
    );
  }

  void _showLabelsMenu(BuildContext context, BookViewBookLoaded state) {
    final bloc = context.read<BookViewBloc>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Закладки',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Colors.grey[700]),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.labels!.length,
                itemBuilder: (context, index) {
                  final label = state.labels![index];
                  final pageNumber = label.page?.number ?? 0;

                  return ListTile(
                    leading: Icon(Icons.bookmark_border),
                    title: Text(
                      label.name ?? 'Закладка ${index + 1}',
                    ),
                    subtitle: Text(
                      'Страница $pageNumber',
                    ),
                    onTap: () {
                      Navigator.pop(modalContext);
                      if (pageNumber > 0) {
                        bloc.add(NavigateToLabel(pageNumber));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BookViewState state) {
    if (state is BookViewInitial || state is BookViewLoadingBook) {
      return Center(
        child: CircularProgressIndicator(),
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
      final bloc = context.read<BookViewBloc>();

      return Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (index) {
                final pageNumber = firstPage + index;
                bloc.add(LoadPage(pageNumber));
              },
              itemBuilder: (context, index) {
                final pageNumber = firstPage + index;
                final bookPage = state.loadedPages[pageNumber];

                if (bookPage == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _BookPageImageView(page: bookPage);
              },
            ),
          ),
          _buildPageIndicator(
              bloc, firstPage, lastPage, state.currentPageNumber),
        ],
      );
    }

    return Container();
  }

  Widget _buildPageIndicator(
      BookViewBloc bloc, int firstPage, int lastPage, int currentPage) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.7 * 255).toInt()),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Страница ${_sliderValue?.round() ?? currentPage} из $lastPage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                thumbColor: Colors.blue,
                overlayColor: Colors.blue.withAlpha((0.2 * 255).toInt()),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: _sliderValue ?? currentPage.toDouble(),
                min: firstPage.toDouble(),
                max: lastPage.toDouble(),
                divisions: lastPage - firstPage,
                label: (_sliderValue?.round() ?? currentPage).toString(),
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                onChangeEnd: (value) {
                  final pageNumber = value.round();
                  bloc.add(NavigateToLabel(pageNumber));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookPageImageView extends StatefulWidget {
  final BookPage page;

  const _BookPageImageView({required this.page});

  @override
  _BookPageImageViewState createState() => _BookPageImageViewState();
}

class _BookPageImageViewState extends State<_BookPageImageView> {
  late TransformationController _transformationController;
  Offset _doubleTapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    const zoomedScale = 2.5;
    final isZoomedIn =
        _transformationController.value.getMaxScaleOnAxis() > 1.0;
    if (isZoomedIn) {
      _transformationController.value = Matrix4.identity();
    } else {
      final dx = -_doubleTapPosition.dx * (zoomedScale - 1);
      final dy = -_doubleTapPosition.dy * (zoomedScale - 1);
      _transformationController.value = Matrix4.identity()
        ..translateByDouble(dx, dy, 0, 1)
        ..scaleByDouble(zoomedScale, zoomedScale, 1, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.page.fileName!;

    return GestureDetector(
      onDoubleTapDown: (details) {
        _doubleTapPosition = details.localPosition;
      },
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
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
      ),
    );
  }
}
