import 'package:flutter/material.dart';
import 'package:sakhatyla/common/theme.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/screens/home.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Саха Тыла',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
