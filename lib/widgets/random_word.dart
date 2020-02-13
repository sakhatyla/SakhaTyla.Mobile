import 'package:flutter/material.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/models/article.dart';
import 'package:sakhatyla/widgets/header.dart';
import 'package:sakhatyla/widgets/html_text.dart';
import 'package:sakhatyla/services/api.dart';

class RandomWord extends StatefulWidget {
  @override
  _RandomWordState createState() => _RandomWordState();
}

class _RandomWordState extends State<RandomWord> {
  final Api _api = locator<Api>();
  Future<Article> article;

  @override
  void initState() {
    super.initState();
    article = _api.getRandomArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Header('Random Article'),
        Card(
          child: FutureBuilder<Article>(
            future: article,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(snapshot.data.title),
                      subtitle: Text('${snapshot.data.fromLanguageName} ⮕ ${snapshot.data.toLanguageName}'),
                      trailing: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _refresh,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HtmlText(snapshot.data.text),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
          )
        )
      ],
    );
  }

  void _refresh() {
    setState(() {
      article = _api.getRandomArticle();
    });    
  }
}


