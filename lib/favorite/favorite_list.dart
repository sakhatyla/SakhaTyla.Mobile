import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/favorite/bloc/favorite_bloc.dart';
import 'package:sakhatyla/favorite/bloc/favorite_event.dart';
import 'package:sakhatyla/favorite/bloc/favorite_state.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/widgets/article_card/article_card.dart';

class FavoriteList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => FavoriteBloc(database: locator<AppDatabase>())..add(Load()),
        child:  BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteEmpty) {
              return Container();
            }
            if (state is FavoriteLoading) {
              return Center(
                child: CircularProgressIndicator()
              );
            }
            if (state is FavoriteSuccess) {
              return ListView.builder(
                  itemCount: state.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ArticleCard(article: state.articles[index]);
                  });
            }
            return Container();
          }
        )
      ),
    );
  }
}
