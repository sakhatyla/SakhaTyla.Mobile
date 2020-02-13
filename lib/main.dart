import 'package:flutter/material.dart';
import 'package:sakhatyla/common/theme.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/screens/home.dart';
import 'package:sakhatyla/screens/search_result.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakha Tyla',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/search': (context) => SearchResult(query: ModalRoute.of(context).settings.arguments),
      },
    );
  }
}
