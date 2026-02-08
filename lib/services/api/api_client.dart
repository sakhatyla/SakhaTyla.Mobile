import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakhatyla/services/api/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final endpoint = dotenv.env['API_ENDPOINT'];

  Future<Article> getRandomArticle() async {
    final response = await http.get(Uri.parse('$endpoint/api/articles/random'));

    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get random article');
    }
  }

  Future<Translation> getTranslation(String query) async {
    var url = Uri.parse('$endpoint/api/articles/translate');
    url = url.replace(queryParameters: {'query': query});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Translation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get translation');
    }
  }

  Future<List<Suggestion>> getSuggestions(String query) async {
    var url = Uri.parse('$endpoint/api/articles/suggest');
    url = url.replace(queryParameters: {'query': query});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((dynamic a) => Suggestion.fromJson(a))
          .toList();
    } else {
      throw Exception('Failed to get suggestions');
    }
  }
}
