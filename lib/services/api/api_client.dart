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

  Future<BooksPage> getBooks({
    int? pageIndex,
    int? pageSize,
    Map<String, dynamic>? filter,
    String? orderBy,
    String? orderDirection,
  }) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/GetBooks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        if (pageIndex != null) 'pageIndex': pageIndex,
        if (pageSize != null) 'pageSize': pageSize,
        if (filter != null) 'filter': filter,
        if (orderBy != null) 'orderBy': orderBy,
        if (orderDirection != null) 'orderDirection': orderDirection,
      }),
    );

    if (response.statusCode == 200) {
      return BooksPage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get books');
    }
  }

  Future<Book> getBook(int id) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/GetBook'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get book');
    }
  }

  Future<BookLabelsPage> getBookLabels({
    int? pageIndex,
    int? pageSize,
    Map<String, dynamic>? filter,
    String? orderBy,
    String? orderDirection,
  }) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/GetBookLabels'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        if (pageIndex != null) 'pageIndex': pageIndex,
        if (pageSize != null) 'pageSize': pageSize,
        if (filter != null) 'filter': filter,
        if (orderBy != null) 'orderBy': orderBy,
        if (orderDirection != null) 'orderDirection': orderDirection,
      }),
    );

    if (response.statusCode == 200) {
      return BookLabelsPage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get book labels');
    }
  }

  Future<BookPage> getBookPageByNumber({
    required int id,
    required int number,
  }) async {
    final response = await http.post(
      Uri.parse('$endpoint/api/public/GetBookPageByNumber'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'number': number,
      }),
    );

    if (response.statusCode == 200) {
      return BookPage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get book page');
    }
  }
}
