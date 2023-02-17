import 'package:flutter/material.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/widgets/article_card.dart';

class FavoriteList extends StatelessWidget {
  final AppDatabase _database = locator<AppDatabase>();
  Future<List<Article>> _articles = Future(() => []);

  FavoriteList() {
    _articles = _database.getFavoriteArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: _articles,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                    child: CircularProgressIndicator()
                )
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData && snapshot.data!.isNotEmpty) {
            var articles = snapshot.data!;
            return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleCard(article: articles[index]);
                });
          } else {
            return Container();
          }
        }
    );
  }
}

