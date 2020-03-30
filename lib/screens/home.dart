import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/blocs/random_article_bloc.dart';
import 'package:sakhatyla/services/api.dart';
import 'package:sakhatyla/widgets/random_article.dart';
import 'package:sakhatyla/widgets/search_bar.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: BlocProvider(
        create: (context) => RandomArticleBloc(api: locator<Api>())..add(Load()),
        child: Column(
          children: <Widget>[
            SearchBar(),
            RandomArticle(),
          ],
        ),
      ),
    );
  }
}
