import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/main/main.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiClient api;
  final AppDatabase database;
  final MainBloc mainBloc;
  final List<StreamSubscription> _subscriptions = [];

  HomeBloc({
    required this.api,
    required this.database,
    required this.mainBloc,
  }) : super(HomeEmpty()) {
    _subscriptions.add(database.onFavoriteArticleAdded.listen(
      (id) => add(FavoriteArticleAdded(id)),
    ));
    _subscriptions.add(database.onFavoriteArticleRemoved.listen(
      (id) => add(FavoriteArticleRemoved(id)),
    ));
    on<Search>((event, emit) async {
      mainBloc.add(ChangeSelectedIndex(0));
      if (event.query.isEmpty) {
        emit(HomeEmpty());
      } else {
        database.addLastQuery(event.query);
        emit(HomeLoading(event.query));
        try {
          var translation = await api.getTranslation(event.query);
          final articleIds = translation.getArticleIds();
          final favoriteArticles =
              await database.getFavoriteArticles(articleIds: articleIds);
          final favoriteArticleIds = favoriteArticles.map((a) => a.id).toList();
          translation =
              translation.copyWith(favoriteArticleIds: favoriteArticleIds);
          emit(HomeSuccess(translation));
        } catch (error) {
          print('Caught error: $error');
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
          print('Caught error: $error');
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
    on<FavoriteArticleAdded>((event, emit) {
      if (state is HomeSuccess) {
        emit(HomeSuccess((state as HomeSuccess)
            .translation
            .copyWith(favoriteArticleIds: [event.id])));
      }
    });
    on<FavoriteArticleRemoved>((event, emit) {
      if (state is HomeSuccess) {
        emit(HomeSuccess((state as HomeSuccess)
            .translation
            .copyWith(notFavoriteArticleIds: [event.id])));
      }
    });
  }

  @override
  Future<void> close() {
    _subscriptions.forEach((s) => s.cancel());
    return super.close();
  }
}
