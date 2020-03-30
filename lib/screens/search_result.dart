import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/search_result_bloc/search_result_bloc.dart';
import 'package:sakhatyla/blocs/search_result_bloc/search_result_event.dart';
import 'package:sakhatyla/blocs/search_result_bloc/search_result_state.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/models/article.dart';
import 'package:sakhatyla/models/translation.dart';
import 'package:sakhatyla/services/api.dart';
import 'package:sakhatyla/widgets/article_card.dart';
import 'package:sakhatyla/widgets/search_bar.dart';

class SearchResult extends StatelessWidget {

  final String query;

  SearchResult({this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: BlocProvider(
        create: (context) => SearchResultBloc(api: locator<Api>()),
        child: BlocBuilder<SearchResultBloc, SearchResultState>(
          builder: (context, state) {
            //ignore: close_sinks
            final searchResultBloc = BlocProvider.of<SearchResultBloc>(context);
            if (state is SearchResultLoading) {
              return CircularProgressIndicator();
            }
            if (state is SearchResultSuccess) {
              return Column(
                children: <Widget>[
                  SearchBar(query: state.translation.query),
                  new Expanded(
                    child: ListView.builder(
                      itemCount: state.translation.articles.fold(0, (int count, ArticleGroup group) => count + group.articles.length),
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleCard(article: _getArticle(state.translation.articles, index));
                      }
                    )
                  )
                ],
              );
            }
            if (state is SearchResultError) {
              return Text("${state.error}");
            }
            searchResultBloc.add(Search(query: query));
            return Text('');
          },
        ),
      ),
    );
  }

  Article _getArticle(List<ArticleGroup> articleGroups, int index) {
    var count = 0;
    for (var i = 0; i < articleGroups.length; i++) {
      for (var j = 0; j < articleGroups[i].articles.length; j++) {
        if (count++ == index)
          return articleGroups[i].articles[j];
      }
    }
    return null;
  }
}

