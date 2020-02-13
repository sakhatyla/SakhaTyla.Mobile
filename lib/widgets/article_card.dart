import 'package:flutter/material.dart';
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(widget.article.title),
            subtitle: Text('${widget.article.fromLanguageName} ⮕ ${widget.article.toLanguageName}'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: HtmlText(widget.article.text),
          )
        ],
      )
    );
  }
}


