import 'package:equatable/equatable.dart';

abstract class RandomArticleEvent extends Equatable {
  const RandomArticleEvent();
}

class Load extends RandomArticleEvent {
  @override
  List<Object> get props => [];
}
