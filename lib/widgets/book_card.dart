import 'package:flutter/material.dart';
import 'package:sakhatyla/book_view/book_view.dart';
import 'package:sakhatyla/services/api/api.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookViewPage(bookId: book.id),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCover(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name ?? 'Без названия',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (book.authors != null && book.authors!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        _getAuthorsText(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                    if (book.firstPage != null && book.lastPage != null) ...[
                      SizedBox(height: 4),
                      Text(
                        'Страницы: ${book.firstPage} - ${book.lastPage}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    if (book.cover != null && book.cover!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          book.cover!,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.book,
        size: 32,
        color: Colors.grey[600],
      ),
    );
  }

  String _getAuthorsText() {
    if (book.authors == null || book.authors!.isEmpty) {
      return '';
    }
    return book.authors!
        .map((a) => a.author?.displayName ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');
  }
}
