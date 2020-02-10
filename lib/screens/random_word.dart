import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sakhatyla/models/article.dart';
import 'package:sakhatyla/screens/html_text.dart';

class RandomWord extends StatefulWidget {
  @override
  _RandomWordState createState() => _RandomWordState();
}

class _RandomWordState extends State<RandomWord> {
  Future<Article> article;

  @override
  void initState() {
    super.initState();
    article = fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }

  void _refresh() {
    setState(() {
      article = fetchArticle();
    });    
  }
}

Future<Article> fetchArticle() async {
  final response = await http.get('https://sakhatyla.ru/api/articles/random');

  if (response.statusCode == 200) {
    return Article.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}
