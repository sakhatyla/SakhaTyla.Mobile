class BookPage {
  final int id;
  final String? fileName;
  final int number;

  BookPage({
    required this.id,
    this.fileName,
    required this.number,
  });

  factory BookPage.fromJson(Map<String, dynamic> json) {
    return BookPage(
      id: json['id'],
      fileName: json['fileName'],
      number: json['number'],
    );
  }
}
