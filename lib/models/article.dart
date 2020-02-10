class Article {
  final int id;  
  final String title;
  final String text;  
  final String fromLanguageName;
  final String toLanguageName;
  final String categoryName;

  Article({this.id, this.title, this.text, this.fromLanguageName, this.toLanguageName, this.categoryName});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['Id'],
      title: json['Title'],
      text: json['Text'],
      fromLanguageName: json['FromLanguageName'],
      toLanguageName: json['ToLanguageName'],
      categoryName: json['CategoryName'],
    );
  }
}