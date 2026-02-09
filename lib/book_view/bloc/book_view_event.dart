import 'package:equatable/equatable.dart';

abstract class BookViewEvent extends Equatable {
  const BookViewEvent();
}

class LoadBook extends BookViewEvent {
  @override
  List<Object> get props => [];
}

class LoadPage extends BookViewEvent {
  final int pageNumber;

  const LoadPage(this.pageNumber);

  @override
  List<Object> get props => [pageNumber];
}

class PreloadPage extends BookViewEvent {
  final int pageNumber;

  const PreloadPage(this.pageNumber);

  @override
  List<Object> get props => [pageNumber];
}
