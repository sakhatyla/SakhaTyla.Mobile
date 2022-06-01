import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiClient api;
  final AppDatabase database;

  HomeBloc({required this.api, required this.database}) : super(HomeEmpty());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is Search) {
      if (event.query.isEmpty) {
        yield HomeEmpty();
      } else {
        database.addLastQuery(event.query);
        yield HomeLoading(event.query);
        try {
          final translation = await api.getTranslation(event.query);
          yield HomeSuccess(translation);
        } catch (error) {
          yield HomeError('error');
        }
      }
    } else if (event is Suggest) {
      if (event.query.length >= 2) {
        try {
          final suggestions = await api.getSuggestions(event.query);
          yield HomeSearching(suggestions);
        } catch (error) {
          yield HomeError('error');
        }
      } else {
        yield HomeEmpty();
      }
    } else if (event is ToggleArtice) {
      if (state is HomeSuccess) {
        yield HomeSuccess((state as HomeSuccess)
            .translation
            .copyWith(toggleArticleId: event.id));
      }
    } else if (event is LastQuery) {
      yield HomeEmpty();
      final queries = await database.getLastQueries();
      if (queries.isEmpty) {
        yield HomeEmpty();
      } else {
        yield HomeHistory(List.generate(
                queries.length,
                (i) => Suggestion(id: 0, title: queries[i])
        ));
      }
    }
  }
}
