import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/home/view/search_bar.dart' as sb;
import 'package:sakhatyla/home/view/suggestion_list.dart';
import 'package:sakhatyla/home/view/translation_list.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => Column(
        children: <Widget>[
          _searchBar(state),
          _main(state),
        ],
      ),
    );
  }

  Widget _searchBar(SearchState state) {
    if (state is SearchLoading) {
      return sb.SearchBar(
        query: state.query,
      );
    }
    if (state is SearchSuccess) {
      return sb.SearchBar(
        query: state.translation.query,
      );
    }
    return sb.SearchBar();
  }

  Widget _main(SearchState state) {
    if (state is SearchSuggesting) {
      return Expanded(child: SuggestionList(state.suggestions));
    }
    if (state is SearchHistory) {
      return Expanded(child: SuggestionList(state.suggestions));
    }
    if (state is SearchLoading) {
      return CircularProgressIndicator();
    }
    if (state is SearchSuccess) {
      return Expanded(child: TranslationList(state.translation));
    }
    if (state is SearchError) {
      return Text('${state.error}');
    }
    return Expanded(child: Container());
  }
}
