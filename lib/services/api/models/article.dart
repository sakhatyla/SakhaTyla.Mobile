class Article {
  final int id;
  final String title;
  final String text;
  final String fromLanguageName;
  final String toLanguageName;
  final String? categoryName;
  final bool collapsed;
  final bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.text,
    required this.fromLanguageName,
    required this.toLanguageName,
    this.categoryName,
    required this.collapsed,
    this.isFavorite = false,
  });

  factory Article.fromJson(
    Map<String, dynamic> json, {
    bool collapsed = false,
  }) {
    return Article(
      id: json['Id'],
      title: json['Title'],
      text: json['Text'],
      fromLanguageName: json['FromLanguageName'],
      toLanguageName: json['ToLanguageName'],
      categoryName: json['CategoryName'],
      collapsed: collapsed,
    );
  }

  Article copyWith({
    int? toggleArticleId,
    List<int>? favoriteArticleIds,
    List<int>? notFavoriteArticleIds,
  }) {
    return Article(
      id: id,
      title: title,
      text: text,
      fromLanguageName: fromLanguageName,
      toLanguageName: toLanguageName,
      categoryName: categoryName,
      collapsed: id == toggleArticleId ? !collapsed : collapsed,
      isFavorite: favoriteArticleIds?.contains(id) == true
          ? true
          : notFavoriteArticleIds?.contains(id) == true
              ? false
              : isFavorite,
    );
  }
}
