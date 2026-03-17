import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/main/main.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/services/error/error.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiClient api;
  final AppDatabase database;
  final MainBloc mainBloc;
  final List<StreamSubscription> _subscriptions = [];

  SearchBloc({
    required this.api,
    required this.database,
    required this.mainBloc,
  }) : super(SearchEmpty()) {
    _subscriptions.add(database.onFavoriteArticleAdded.listen(
      (id) => add(FavoriteArticleAdded(id)),
    ));
    _subscriptions.add(database.onFavoriteArticleRemoved.listen(
      (id) => add(FavoriteArticleRemoved(id)),
    ));
    on<Search>((event, emit) async {
      mainBloc.add(ChangeSelectedIndex(1));
      if (event.query.isEmpty) {
        emit(SearchEmpty());
      } else {
        database.addLastQuery(event.query);
        emit(SearchLoading(event.query));
        await FirebaseAnalytics.instance.logEvent(
          name: 'search',
          parameters: {
            'query': event.query,
          },
        );
        try {
          var translation = await api.getTranslation(event.query);
          final articleIds = translation.getArticleIds();
          final favoriteArticles =
              await database.getFavoriteArticles(articleIds: articleIds);
          final favoriteArticleIds = favoriteArticles.map((a) => a.id).toList();
          translation =
              translation.copyWith(favoriteArticleIds: favoriteArticleIds);
          emit(SearchSuccess(translation));
        } catch (err, s) {
          reportError(err, s);
          emit(SearchError('error'));
        }
      }
    });
    on<Suggest>((event, emit) async {
      if (event.query.length >= 2) {
        try {
          final suggestions = await api.getSuggestions(event.query);
          emit(SearchSuggesting(suggestions));
        } catch (err, s) {
          reportError(err, s);
          emit(SearchError('error'));
        }
      } else {
        emit(SearchEmpty());
      }
    });
    on<ToggleArticle>((event, emit) {
      if (state is SearchSuccess) {
        emit(SearchSuccess((state as SearchSuccess)
            .translation
            .copyWith(toggleArticleId: event.id)));
      }
    });
    on<LastQuery>((event, emit) async {
      emit(SearchEmpty());
      final queries = await database.getLastQueries();
      if (queries.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchHistory(List.generate(
          queries.length,
          (i) => Suggestion(id: 0, title: queries[i]),
        )));
      }
    });
    on<FavoriteArticleAdded>((event, emit) {
      if (state is SearchSuccess) {
        emit(SearchSuccess((state as SearchSuccess)
            .translation
            .copyWith(favoriteArticleIds: [event.id])));
      }
    });
    on<FavoriteArticleRemoved>((event, emit) {
      if (state is SearchSuccess) {
        emit(SearchSuccess((state as SearchSuccess)
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
