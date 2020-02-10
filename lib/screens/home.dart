import 'package:flutter/material.dart';
import 'package:sakhatyla/screens/random_word.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sakha Tyla"),
      ),
      body: Column(
        children: <Widget>[
          RandomWord(),
        ],
      ),
    );
  }
}
