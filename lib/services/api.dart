import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakhatyla/models/article.dart';

class Api {
  static const endpoint = 'https://sakhatyla.ru';

  Future<Article> getRandomArticle() async {
    final response = await http.get('$endpoint/api/articles/random');

    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
