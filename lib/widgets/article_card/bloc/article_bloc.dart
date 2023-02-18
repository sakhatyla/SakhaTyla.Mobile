import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/widgets/article_card/bloc/article_state.dart';

import 'article_event.dart';

class ArticleFavoriteBloc extends Bloc<ArticleFavoriteEvent, ArticleFavoriteState> {
  final AppDatabase _database;

  ArticleFavoriteBloc({
    required AppDatabase database,
  })  : _database = database,
        super(ArticleFavoriteState(false)) {
    on<InitArticle>((event, emit) async {
      var isFavorite = await _database.isArticleFavorite(event.id);
      emit(ArticleFavoriteState(isFavorite));
    });
    on<ClickArticle>((event, emit) async {
      var isFavorite = await _database.isArticleFavorite(event.article.id);
      if (isFavorite) {
        await _database.removeFavoriteArticle(event.article.id);
      } else {
        await _database.addFavoriteArticle(event.article);
      }
      emit(ArticleFavoriteState(!isFavorite));
    });
  }
}
