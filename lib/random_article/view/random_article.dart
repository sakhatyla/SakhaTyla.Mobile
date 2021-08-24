import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/widgets/header.dart';
import 'package:sakhatyla/widgets/html_text.dart';

class RandomArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Header('Случайная статья'),
            )
          ],
        ),
        Card(child: BlocBuilder<RandomArticleBloc, RandomArticleState>(
            builder: (context, state) {
          if (state is RandomArticleLoading) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is RandomArticleSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                    title: Text(state.article.title),
                    subtitle: Text(
                        '${state.article.fromLanguageName} → ${state.article.toLanguageName}'),
                    trailing: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        BlocProvider.of<RandomArticleBloc>(context).add(Load());
                      },
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HtmlText(state.article.text),
                ),
                state.article.categoryName != null &&
                        state.article.categoryName!.isNotEmpty
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Text(
                            'Категория: ${state.article.categoryName}',
                          style: TextStyle(fontStyle: FontStyle.italic)
                        )
                )
                    : Container()
              ],
            );
          }
          if (state is RandomArticleError) {
            return Text('${state.error}');
          }
          return Text('');
        }))
      ],
    );
  }
}
