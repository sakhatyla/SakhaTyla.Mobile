import 'package:equatable/equatable.dart';

class ArticleFavoriteState extends Equatable {
  final bool isFavorite;

  const ArticleFavoriteState(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}
