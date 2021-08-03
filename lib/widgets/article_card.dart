import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/widgets/html_text.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  ArticleCard({required this.article});

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
      onLongPress: _copyToClipboard,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(widget.article.title),
              subtitle: !widget.article.collapsed
                  ? Text(
                      '${widget.article.fromLanguageName} → ${widget.article.toLanguageName}')
                  : null,
            ),
            !widget.article.collapsed
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HtmlText(widget.article.text),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _copyToClipboard() {
    Clipboard.setData(
      ClipboardData(
          text:
              "${widget.article.title}\n${_removeHtmlTags(widget.article.text)}"),
    ).then((result) {
      final snackBar = SnackBar(
        content: Text('Текст скопирован'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  String? _removeHtmlTags(String text) {
    var document = parse(text);
    return document.body?.text;
  }
}
