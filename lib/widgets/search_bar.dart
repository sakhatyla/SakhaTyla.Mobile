import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/blocs/home_bloc.dart';

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
      onChanged: (text) {
        setState(() {
        });
      },
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
              _search("");
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
    BlocProvider.of<HomeBloc>(context).add(Search(query: text));
  }
}