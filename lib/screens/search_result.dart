import 'package:flutter/material.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/models/article.dart';
import 'package:sakhatyla/models/translation.dart';
import 'package:sakhatyla/services/api.dart';
import 'package:sakhatyla/widgets/article_card.dart';
import 'package:sakhatyla/widgets/search_bar.dart';

class SearchResult extends StatefulWidget {

  final String query;

  SearchResult({this.query});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final Api _api = locator<Api>();
  Future<Translation> translation;

  @override
  void initState() {
    super.initState();
    translation = _api.getTranslation(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: FutureBuilder<Translation>(
        future: translation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                SearchBar(query: snapshot.data.query),
                new Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.articles.fold(0, (int count, ArticleGroup group) => count + group.articles.length),
                    itemBuilder: (BuildContext context, int index) {
                      return ArticleCard(article: _getArticle(snapshot.data.articles, index));
                    }
                  )
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
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

