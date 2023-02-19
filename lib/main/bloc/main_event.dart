import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class ChangeSelectedIndex extends MainEvent {
  final int selectedIndex;
  ChangeSelectedIndex(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
