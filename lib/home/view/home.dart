import 'package:flutter/material.dart';
import 'package:sakhatyla/ads/ads.dart';
import 'package:sakhatyla/random_article/random_article.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
