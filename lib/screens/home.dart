import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/blocs/random_article_bloc.dart';
import 'package:sakhatyla/models/translation.dart';
import 'package:sakhatyla/services/api.dart';
import 'package:sakhatyla/widgets/article_card.dart';
import 'package:sakhatyla/widgets/header.dart';
import 'package:sakhatyla/widgets/random_article.dart';
import 'package:sakhatyla/widgets/search_bar.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(api: locator<Api>())
          ),
          BlocProvider(
            create: (context) => RandomArticleBloc(api: locator<Api>())..add(Load())
          ),
        ],
        child: Column(
          children: <Widget>[
            SearchBar(),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeEmpty) {
                  return RandomArticle();
                }
                if (state is HomeLoading) {
                  return CircularProgressIndicator();
                }
                if (state is HomeSuccess) {
                  return new Expanded(
                    child: ListView.builder(
                      itemCount: _getCount(state.translation),
                      itemBuilder: (BuildContext context, int index) {
                        return _getItem(state.translation, index);
                      }
                    )
                  );
                }
                if (state is HomeError) {
                  return Text('${state.error}');
                }
                return Text('');
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getCount(Translation translation) {
    return translation.articles.fold(0, (int count, ArticleGroup group) => count + group.articles.length) + 
      1 + // More translations
      translation.moreArticles.length;
  }

  Widget _getItem(Translation translation, int index) {
    var count = 0;
    for (var i = 0; i < translation.articles.length; i++) {
      for (var j = 0; j < translation.articles[i].articles.length; j++) {
        if (count++ == index)
          return ArticleCard(article: translation.articles[i].articles[j]);
      }
    }
    if (count++ == index) {
      return Header('More translations');
    }
    for (var i = 0; i < translation.moreArticles.length; i++) {
      if (count++ == index)
        return ArticleCard(article: translation.moreArticles[i]);
    }
    return null;
  }
}
