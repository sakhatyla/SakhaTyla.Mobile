import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/ads/ads.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              RandomArticleBloc(api: locator<ApiClient>())..add(Load()),
        ),
        BlocProvider(
          create: (context) => AdsBloc(apiClient: locator<ApiClient>()),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            RandomArticle(),
            LayoutBuilder(
              builder: (context, constraints) => AdsBanner(
                width: constraints.maxWidth.toInt(),
                maxHeight: (constraints.maxWidth / 4 * 3).toInt(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
