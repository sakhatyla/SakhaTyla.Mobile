class Book {
  final int id;
  final String? name;
  final String? synonym;
  final String? cover;
  final List<BookAuthorship>? authors;
  final int? firstPage;
  final int? lastPage;

  Book({
    required this.id,
    this.name,
    this.synonym,
    this.cover,
    this.authors,
    this.firstPage,
    this.lastPage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      synonym: json['synonym'],
      cover: json['cover'],
      authors: json['authors'] != null
          ? (json['authors'] as List<dynamic>)
              .map((a) => BookAuthorship.fromJson(a))
              .toList()
          : null,
      firstPage: json['firstPage'],
      lastPage: json['lastPage'],
    );
  }
}

class BookAuthorship {
  final int id;
  final int bookId;
  final int bookAuthorId;
  final String? bookAuthorName;

  BookAuthorship({
    required this.id,
    required this.bookId,
    required this.bookAuthorId,
    this.bookAuthorName,
  });

  factory BookAuthorship.fromJson(Map<String, dynamic> json) {
    return BookAuthorship(
      id: json['id'] ?? 0,
      bookId: json['bookId'] ?? 0,
      bookAuthorId: json['bookAuthorId'] ?? 0,
      bookAuthorName: json['bookAuthor']?['name'],
    );
  }
}

class BooksPage {
  final List<Book> items;
  final int totalItems;
  final int currentPageIndex;

  BooksPage({
    required this.items,
    required this.totalItems,
    required this.currentPageIndex,
  });

  factory BooksPage.fromJson(Map<String, dynamic> json) {
    return BooksPage(
      items: (json['pageItems'] as List<dynamic>?)
              ?.map((item) => Book.fromJson(item))
              .toList() ??
          [],
      totalItems: json['totalItems'] ?? 0,
      currentPageIndex: json['currentPageIndex'] ?? 0,
    );
  }
}
