import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiClient api;
  final AppDatabase database;

  HomeBloc({required this.api, required this.database}) : super(HomeEmpty()) {
    on<Search>((event, emit) async {
      if (event.query.isEmpty) {
        emit(HomeEmpty());
      } else {
        database.addLastQuery(event.query);
        emit(HomeLoading(event.query));
        try {
          final translation = await api.getTranslation(event.query);
          emit(HomeSuccess(translation));
        } catch (error) {
          emit(HomeError('error'));
        }
      }
    });
    on<Suggest>((event, emit) async {
      if (event.query.length >= 2) {
        try {
          final suggestions = await api.getSuggestions(event.query);
          emit(HomeSearching(suggestions));
        } catch (error) {
          emit(HomeError('error'));
        }
      } else {
        emit(HomeEmpty());
      }
    });
    on<ToggleArticle>((event, emit) {
      if (state is HomeSuccess) {
        emit(HomeSuccess((state as HomeSuccess)
            .translation
            .copyWith(toggleArticleId: event.id)));
      }
    });
    on<LastQuery>((event, emit) async {
      emit(HomeEmpty());
      final queries = await database.getLastQueries();
      if (queries.isEmpty) {
        emit(HomeEmpty());
      } else {
        emit(HomeHistory(List.generate(
          queries.length,
          (i) => Suggestion(id: 0, title: queries[i]),
        )));
      }
    });
  }
}
