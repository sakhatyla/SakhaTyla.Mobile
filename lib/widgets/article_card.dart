import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:sakhatyla/favorite/favorite.dart';
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
  static const double _maxCollapsedHeight = 150.0;

  bool _isExpanded = false;
  bool _overflows = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scheduleOverflowCheck();
  }

  @override
  void didUpdateWidget(ArticleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.article.id != widget.article.id ||
        oldWidget.article.text != widget.article.text ||
        oldWidget.article.collapsed != widget.article.collapsed) {
      _isExpanded = false;
      _overflows = false;
      _scheduleOverflowCheck();
    }
  }

  void _scheduleOverflowCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox =
          _textKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final overflows = renderBox.size.height > _maxCollapsedHeight;
        if (_overflows != overflows) {
          setState(() => _overflows = overflows);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surfaceContainerLow;

    return GestureDetector(
      onTap: () {
        BlocProvider.of<SearchBloc>(context)
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
                icon: Icon(
                    widget.article.isFavorite ? Icons.star : Icons.star_border),
                onPressed: () => {
                  BlocProvider.of<FavoriteBloc>(context)
                      .add(ToggleArticleFavorite(widget.article))
                },
              ),
            ),
            if (!widget.article.collapsed)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _isExpanded
                    ? HtmlText(widget.article.text)
                    : Stack(
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: _maxCollapsedHeight),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                key: _textKey,
                                child: HtmlText(widget.article.text),
                              ),
                            ),
                          ),
                          if (_overflows)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 40,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      cardColor.withValues(alpha: 0),
                                      cardColor,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            if (!widget.article.collapsed && _overflows)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(_isExpanded ? 'Свернуть' : 'Развернуть'),
                ),
              ),
            if (!widget.article.collapsed &&
                widget.article.categoryName != null &&
                widget.article.categoryName!.isNotEmpty)
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text('Категория: ${widget.article.categoryName}',
                      style: TextStyle(fontStyle: FontStyle.italic)))
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
