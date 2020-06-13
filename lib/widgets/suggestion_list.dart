import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc.dart';
import 'package:sakhatyla/models/suggestion.dart';

class SuggestionList extends StatelessWidget {
  final List<Suggestion> suggestions;

  SuggestionList(this.suggestions);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _getCount(suggestions),
      itemBuilder: (BuildContext context, int index) {
        return _getItem(suggestions, index, context);
      }, 
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  int _getCount(List<Suggestion> suggestions) {
    return suggestions.length;
  }

  Widget _getItem(List<Suggestion> suggestions, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<HomeBloc>(context).add(Search(query: suggestions[index].title));
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20), 
        child: Text(suggestions[index].title),
      ),
    );
  }
}