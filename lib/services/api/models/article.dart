class Article {
  final int id;  
  final String title;
  final String text;  
  final String fromLanguageName;
  final String toLanguageName;
  final String categoryName;
  final bool collapsed;

  Article({this.id, this.title, this.text, this.fromLanguageName, this.toLanguageName, this.categoryName, this.collapsed});

  factory Article.fromJson(Map<String, dynamic> json, {bool collapsed = false}) {
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

  Article copyWith({int toggleArticleId}) {
    return Article(
      id: id,
      title: title, 
      text: text,
      fromLanguageName: fromLanguageName,
      toLanguageName: toLanguageName,
      categoryName: categoryName,
      collapsed: id == toggleArticleId ? !collapsed : collapsed,
    );
  }
}