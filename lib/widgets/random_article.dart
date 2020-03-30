import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/random_article_bloc.dart';
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
              child: Header('Random Article'),
            )
          ],
        ),
        Card(
          child: BlocBuilder<RandomArticleBloc, RandomArticleState>(
            builder: (context, state) {
              if (state is RandomArticleLoading) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              } 
              if (state is RandomArticleSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(state.article.title),
                      subtitle: Text('${state.article.fromLanguageName} ⮕ ${state.article.toLanguageName}'),
                      trailing: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          BlocProvider.of<RandomArticleBloc>(context).add(Load());
                        },
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HtmlText(state.article.text),
                    )
                  ],
                );
              }
              if (state is RandomArticleError) {
                return Text('${state.error}');
              }
              return Text('');
            }
          )
        )
      ],
    );
  }

}
