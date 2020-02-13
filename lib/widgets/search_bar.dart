import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    //textController.addListener(_printLatestValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onSubmitted: _search,
      decoration: InputDecoration(
        hintText: 'Enter a text'
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // _printLatestValue() {
  //   print("Text field: ${textController.text}");
  // }

  _search(String text) {
    print(text);
  }
}