import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/search_result_bloc/search_result_event.dart';
import 'package:sakhatyla/blocs/search_result_bloc/search_result_state.dart';
import 'package:sakhatyla/services/api.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final Api api;

  SearchResultBloc({@required this.api});

  @override
  SearchResultState get initialState => SearchResultEmpty();

  @override
  Stream<SearchResultState> mapEventToState(SearchResultEvent event) async* {
    if (event is Search) {
      yield SearchResultLoading();
      try {
        final translation = await api.getTranslation(event.query);
        yield SearchResultSuccess(translation);
      } catch (error) {
        yield SearchResultError('error');
      }
    }
  }

}