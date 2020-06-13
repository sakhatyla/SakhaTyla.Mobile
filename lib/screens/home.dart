import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/blocs/random_article_bloc.dart';
import 'package:sakhatyla/services/api.dart';
import 'package:sakhatyla/widgets/random_article.dart';
import 'package:sakhatyla/widgets/search_bar.dart';
import 'package:sakhatyla/widgets/suggestion_list.dart';
import 'package:sakhatyla/widgets/translation_list.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(api: locator<Api>())
          ),
          BlocProvider(
            create: (context) => RandomArticleBloc(api: locator<Api>())..add(Load())
          ),
        ],
        child: Column(
          children: <Widget>[
            SearchBar(),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeEmpty) {
                  return RandomArticle();
                }
                if (state is HomeSearching) {
                  return Expanded(
                    child: SuggestionList(state.suggestions)
                  );
                }
                if (state is HomeLoading) {
                  return CircularProgressIndicator();
                }
                if (state is HomeSuccess) {
                  return Expanded(
                    child: TranslationList(state.translation)
                  );
                }
                if (state is HomeError) {
                  return Text('${state.error}');
                }
                return Text('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
