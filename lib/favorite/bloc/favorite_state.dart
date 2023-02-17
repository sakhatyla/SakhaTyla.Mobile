import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteEmpty extends FavoriteState {}

class FavoriteLoading extends FavoriteState {

  const FavoriteLoading();

  List<Object> get props => [];
}

class FavoriteSuccess extends FavoriteState {
  final List<Article> articles;

  const FavoriteSuccess(this.articles);

  @override
  List<Object> get props => [articles];
}
