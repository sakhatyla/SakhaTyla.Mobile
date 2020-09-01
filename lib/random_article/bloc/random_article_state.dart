import 'package:equatable/equatable.dart';
import 'package:sakhatyla/services/api/api.dart';

abstract class RandomArticleState extends Equatable {
  const RandomArticleState();

  @override
  List<Object> get props => [];
}

class RandomArticleEmpty extends RandomArticleState {}

class RandomArticleLoading extends RandomArticleState {}

class RandomArticleSuccess extends RandomArticleState {
  final Article article;

  const RandomArticleSuccess(this.article);

  @override
  List<Object> get props => [article];
}

class RandomArticleError extends RandomArticleState {
  final String error;

  const RandomArticleError(this.error);

  @override
  List<Object> get props => [error];
}
