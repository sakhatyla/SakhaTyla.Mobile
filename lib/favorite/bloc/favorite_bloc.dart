import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/favorite/bloc/favorite_event.dart';
import 'package:sakhatyla/favorite/bloc/favorite_state.dart';
import 'package:sakhatyla/services/database/database.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AppDatabase _database;

  FavoriteBloc({
    required AppDatabase database,
  }) : _database = database, super(FavoriteEmpty()) {
    on<Load>((event, emit) async {
      emit(FavoriteLoading());
      var articles = await _database.getFavoriteArticles();
      if (articles.isEmpty) {
        emit(FavoriteEmpty());
      } else {
        emit(FavoriteSuccess(articles));
      }
    });
  }
}
