import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/widgets/article_card/bloc/article_bloc.dart';
import 'package:sakhatyla/widgets/article_card/bloc/article_event.dart';
import 'package:sakhatyla/widgets/article_card/bloc/article_state.dart';
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
        BlocProvider.of<HomeBloc>(context)
            .add(ToggleArticle(widget.article.id));
      },
      onLongPress: _copyToClipboard,
      child: BlocProvider(
        create: (context) => ArticleFavoriteBloc(database: locator<AppDatabase>())..add(InitArticle(widget.article.id)),
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
                  trailing: BlocBuilder<ArticleFavoriteBloc, ArticleFavoriteState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(state.isFavorite ? Icons.star : Icons.star_border),
                          onPressed: () => {
                            BlocProvider.of<ArticleFavoriteBloc>(context)
                                .add(ClickArticle(widget.article))
                          },
                        );
                      })
              ),
              !widget.article.collapsed
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HtmlText(widget.article.text),
              )
                  : Container(),
              !widget.article.collapsed &&
                  widget.article.categoryName != null &&
                  widget.article.categoryName!.isNotEmpty
                  ? Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text('Категория: ${widget.article.categoryName}',
                      style: TextStyle(fontStyle: FontStyle.italic)))
                  : Container()
            ],
          ),
        ),
      )
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
