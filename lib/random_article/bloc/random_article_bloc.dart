import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';

class RandomArticleBloc extends Bloc<RandomArticleEvent, RandomArticleState> {
  final ApiClient api;

  RandomArticleBloc({required this.api}) : super(RandomArticleEmpty());

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
