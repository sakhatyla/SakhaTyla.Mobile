import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/random_article_bloc/random_article_event.dart';
import 'package:sakhatyla/blocs/random_article_bloc/random_article_state.dart';
import 'package:sakhatyla/services/api.dart';

class RandomArticleBloc extends Bloc<RandomArticleEvent, RandomArticleState> {
  final Api api;

  RandomArticleBloc({@required this.api}) : super(RandomArticleEmpty());

  @override
  Stream<RandomArticleState> mapEventToState(RandomArticleEvent event) async* {
    if (event is Load) {
      yield RandomArticleLoading();
      try {
        final article = await api.getRandomArticle();
        yield RandomArticleSuccess(article);
      } catch (error) {
        yield RandomArticleError('error');
      }
    }
  }
}
