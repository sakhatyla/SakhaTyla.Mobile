import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/widgets/html_text.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  final AppDatabase _database = locator<AppDatabase>();
  Future<bool> _isFavorite = Future(() => false);

  @override
  void initState() {
    super.initState();

    _isFavorite = _database.isArticleFavorite(widget.article.id);
  }

  void _clickFavorite() async {
    bool favorite = await _isFavorite;
    if (favorite) {
      await _database.removeFavoriteArticle(widget.article.id);
    } else {
      await _database.addFavoriteArticle(widget.article);
    }
    setState(() {
      _isFavorite = Future(() => !favorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<HomeBloc>(context)
            .add(ToggleArticle(widget.article.id));
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
              trailing: IconButton(
                  icon: FutureBuilder<bool>(
                      future: _isFavorite,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData) {
                          return Icon(snapshot.data! ? Icons.star : Icons.star_border);
                        } else {
                          return Icon(Icons.star_border);
                        }
                      }),
                  onPressed: _clickFavorite),
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
