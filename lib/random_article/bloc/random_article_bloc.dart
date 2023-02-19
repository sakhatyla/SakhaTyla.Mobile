import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';

class RandomArticleBloc extends Bloc<RandomArticleEvent, RandomArticleState> {
  final ApiClient api;

  RandomArticleBloc({required this.api}) : super(RandomArticleEmpty()) {
    on<Load>((event, emit) async {
      emit(RandomArticleLoading());
      try {
        final article = await api.getRandomArticle();
        emit(RandomArticleSuccess(article));
      } catch (error) {
        print('Caught error: $error');
        emit(RandomArticleError('error'));
      }
    });
  }
}
