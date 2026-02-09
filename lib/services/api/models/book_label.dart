import 'book_page.dart';

class BookLabel {
  final int id;
  final int bookId;
  final String? name;
  final int pageId;
  final BookPage? page;

  BookLabel({
    required this.id,
    required this.bookId,
    this.name,
    required this.pageId,
    this.page,
  });

  factory BookLabel.fromJson(Map<String, dynamic> json) {
    return BookLabel(
      id: json['id'],
      bookId: json['bookId'],
      name: json['name'],
      pageId: json['pageId'],
      page: json['page'] != null ? BookPage.fromJson(json['page']) : null,
    );
  }
}

class BookLabelsPage {
  final List<BookLabel> items;
  final int totalItems;
  final int currentPageIndex;

  BookLabelsPage({
    required this.items,
    required this.totalItems,
    required this.currentPageIndex,
  });

  factory BookLabelsPage.fromJson(Map<String, dynamic> json) {
    return BookLabelsPage(
      items: (json['pageItems'] as List<dynamic>?)
              ?.map((item) => BookLabel.fromJson(item))
              .toList() ??
          [],
      totalItems: json['totalItems'] ?? 0,
      currentPageIndex: json['currentPageIndex'] ?? 0,
    );
  }
}
