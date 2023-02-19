import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/favorite/favorite.dart';
import 'package:sakhatyla/widgets/article_card.dart';

class FavoriteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteEmpty) {
            return Container();
          }
          if (state is FavoriteLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FavoriteSuccess) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ArticleCard(article: state.articles[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
