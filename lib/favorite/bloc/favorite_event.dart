import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class Load extends FavoriteEvent {
  @override
  List<Object> get props => [];
}
