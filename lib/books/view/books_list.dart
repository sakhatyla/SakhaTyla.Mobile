import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/books/books.dart';
import 'package:sakhatyla/widgets/book_card.dart';

class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksEmpty) {
            return Center(
              child: Text('Нет книг'),
            );
          }
          if (state is BooksLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is BooksSuccess) {
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (BuildContext context, int index) {
                return BookCard(book: state.books[index]);
              },
            );
          }
          if (state is BooksError) {
            return Center(
              child: Text('Ошибка: ${state.error}'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
