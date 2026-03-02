import 'package:equatable/equatable.dart';

abstract class KeyboardEvent extends Equatable {
  const KeyboardEvent();
}

class KeyboardVisibilityChanged extends KeyboardEvent {
  final bool isVisible;

  const KeyboardVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
