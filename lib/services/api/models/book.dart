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

class BookAuthor {
  final int id;
  final String? lastName;
  final String? firstName;
  final String? middleName;

  BookAuthor({
    required this.id,
    this.lastName,
    this.firstName,
    this.middleName,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> json) {
    return BookAuthor(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      middleName: json['middleName'],
    );
  }

  String get displayName {
    final parts = <String>[];
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (middleName != null && middleName!.isNotEmpty) parts.add(middleName!);
    return parts.isNotEmpty ? parts.join(' ') : '';
  }
}

class BookAuthorship {
  final int id;
  final int authorId;
  final BookAuthor? author;
  final int weight;

  BookAuthorship({
    required this.id,
    required this.authorId,
    this.author,
    required this.weight,
  });

  factory BookAuthorship.fromJson(Map<String, dynamic> json) {
    return BookAuthorship(
      id: json['id'],
      authorId: json['authorId'],
      author: json['author'] != null ? BookAuthor.fromJson(json['author']) : null,
      weight: json['weight'] ?? 0,
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
