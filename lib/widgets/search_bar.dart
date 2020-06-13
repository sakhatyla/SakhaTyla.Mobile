import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final String query;

  SearchBar({this.query});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onSubmitted: _search,
      decoration: InputDecoration(        
        hintText: 'Enter a text',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: textController.text.length > 0 ? 
          IconButton(
            icon: Icon(Icons.clear), 
            onPressed: () {
              setState(() {
                textController.clear();
              });
            },
          ) : null
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  _search(String text) {
    Navigator.pushNamed(context, '/search', arguments: text);
  }
}