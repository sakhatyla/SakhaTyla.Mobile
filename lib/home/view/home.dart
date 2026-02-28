import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/ads/ads.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/home/view/search_bar.dart' as sb;
import 'package:sakhatyla/home/view/suggestion_list.dart';
import 'package:sakhatyla/home/view/translation_list.dart';

class Home extends StatelessWidget {
  final bool isKeyboardVisible;

  Home({this.isKeyboardVisible = false}) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                RandomArticleBloc(api: locator<ApiClient>())..add(Load()),
          ),
          BlocProvider(
            create: (context) => AdsBloc(apiClient: locator<ApiClient>()),
          ),
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
      return sb.SearchBar(
        query: state.query,
        showSakhaLetters: this.isKeyboardVisible,
      );
    }
    if (state is HomeSuccess) {
      return sb.SearchBar(
        query: state.translation.query,
        showSakhaLetters: this.isKeyboardVisible,
      );
    }
    return sb.SearchBar(
      showSakhaLetters: this.isKeyboardVisible,
    );
  }

  Widget _main(HomeState state) {
    if (state is HomeEmpty) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RandomArticle(),
              LayoutBuilder(
                builder: (context, constraints) => AdsBanner(
                  width: constraints.maxWidth.toInt(),
                  maxHeight: (constraints.maxWidth / 4 * 3).toInt(),
                ),
              ),
            ],
          ),
        ),
      );
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
