class Suggestion {
  final int id;  
  final String title;

  Suggestion({required this.id, required this.title});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'],
      title: json['title'] ?? '',
    );
  }
}