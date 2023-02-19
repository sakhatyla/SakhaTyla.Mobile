import 'package:flutter/material.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/widgets/article_card.dart';
import 'package:sakhatyla/widgets/header.dart';

class TranslationList extends StatelessWidget {
  final Translation translation;

  TranslationList(this.translation);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _getCount(translation),
        itemBuilder: (BuildContext context, int index) {
          return _getItem(translation, index);
        });
  }

  int _getCount(Translation translation) {
    return (translation.articles.length > 0
            ? translation.articles.fold(
                0,
                (int count, ArticleGroup group) =>
                    count + group.articles.length)
            : 1) +
        (translation.moreArticles.length > 0
            ? translation.moreArticles.length + 1
            : 0);
  }

  Widget _getItem(Translation translation, int index) {
    var count = 0;
    if (translation.articles.length > 0) {
      for (var i = 0; i < translation.articles.length; i++) {
        for (var j = 0; j < translation.articles[i].articles.length; j++) {
          if (count++ == index)
            return ArticleCard(article: translation.articles[i].articles[j]);
        }
      }
    } else {
      if (count++ == index)
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text("Ничего не найдено"),
        );
    }
    if (translation.moreArticles.length > 0) {
      if (count++ == index) {
        return Header('Еще переводы');
      }
      for (var i = 0; i < translation.moreArticles.length; i++) {
        if (count++ == index)
          return ArticleCard(article: translation.moreArticles[i]);
      }
    }
    return Container();
  }
}
