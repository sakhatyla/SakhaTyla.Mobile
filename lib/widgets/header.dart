import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;

  Header(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Text(
        text, 
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}