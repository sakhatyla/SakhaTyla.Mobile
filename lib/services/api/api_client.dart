import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakhatyla/services/api/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final endpoint = dotenv.env['API_ENDPOINT'];

  Future<Article> getRandomArticle() async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/GetRandomArticle'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get random article');
    }
  }

  Future<Translation> getTranslation(String query) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/Translate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      return Translation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get translation');
    }
  }

  Future<List<Suggestion>> getSuggestions(String query) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/SuggestArticles'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((dynamic a) => Suggestion.fromJson(a))
          .toList();
    } else {
      throw Exception('Failed to get suggestions');
    }
  }
}
