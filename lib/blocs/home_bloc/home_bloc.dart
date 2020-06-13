import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc/home_event.dart';
import 'package:sakhatyla/blocs/home_bloc/home_state.dart';
import 'package:sakhatyla/services/api.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Api api;

  HomeBloc({@required this.api});

  @override
  HomeState get initialState => HomeEmpty();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is Search) {
      if (event.query.isEmpty) {
        yield HomeEmpty();
      } else {
        yield HomeLoading();
        try {
          final translation = await api.getTranslation(event.query);
          yield HomeSuccess(translation);
        } catch (error) {
          yield HomeError('error');
        }
      }
    }
  }

}