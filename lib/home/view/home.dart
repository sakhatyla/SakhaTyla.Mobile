import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/home/view/search_bar.dart' as sb;
import 'package:sakhatyla/home/view/suggestion_list.dart';
import 'package:sakhatyla/home/view/translation_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                RandomArticleBloc(api: locator<ApiClient>())..add(Load()),
          )
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => Column(
            children: <Widget>[
              _searchBar(state),
              _main(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(HomeState state) {
    if (state is HomeLoading) {
      return sb.SearchBar(query: state.query);
    }
    if (state is HomeSuccess) {
      return sb.SearchBar(query: state.translation.query);
    }
    return sb.SearchBar();
  }

  Widget _main(HomeState state) {
    if (state is HomeEmpty) {
      return RandomArticle();
    }
    if (state is HomeSearching) {
      return Expanded(child: SuggestionList(state.suggestions));
    }
    if (state is HomeHistory) {
      return Expanded(child: SuggestionList(state.suggestions));
    }
    if (state is HomeLoading) {
      return CircularProgressIndicator();
    }
    if (state is HomeSuccess) {
      return Expanded(child: TranslationList(state.translation));
    }
    if (state is HomeError) {
      return Text('${state.error}');
    }
    return Text('');
  }
}
