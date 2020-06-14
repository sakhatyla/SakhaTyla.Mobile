import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc.dart';
import 'package:sakhatyla/models/article.dart';
import 'package:sakhatyla/widgets/html_text.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  ArticleCard({this.article});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<HomeBloc>(context).add(ToggleArtice(widget.article.id));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(widget.article.title),
              subtitle: !widget.article.collapsed ? Text('${widget.article.fromLanguageName} ⮕ ${widget.article.toLanguageName}') : null,
            ),
            !widget.article.collapsed ? 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HtmlText(widget.article.text),
              ) :
              Container()
          ],
        )
      ),
    );
  }
}


