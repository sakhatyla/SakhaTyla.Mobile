class Suggestion {
  final int id;  
  final String title;

  Suggestion({this.id, this.title});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['Id'],
      title: json['Title'],
    );
  }
}