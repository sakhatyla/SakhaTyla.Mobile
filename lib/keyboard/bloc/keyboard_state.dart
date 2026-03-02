import 'package:equatable/equatable.dart';

class KeyboardBlocState extends Equatable {
  final bool isVisible;

  const KeyboardBlocState({this.isVisible = false});

  @override
  List<Object> get props => [isVisible];
}
