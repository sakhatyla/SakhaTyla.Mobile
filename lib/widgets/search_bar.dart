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
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        setState(() {
          if (state is HomeSuccess) {
            textController.text = state.query;
          }          
        });
      },
      child: TextField(
        controller: textController,
        onSubmitted: _search,
        onChanged: (text) {
          setState(() {
          });
          BlocProvider.of<HomeBloc>(context).add(Suggest(query: text));
        },
        decoration: InputDecoration(        
          hintText: 'Enter a text',
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: textController.text.length > 0 ? 
            IconButton(
              icon: Icon(Icons.clear), 
              onPressed: () {
                setState(() {
                  // https://github.com/flutter/flutter/issues/17647
                  WidgetsBinding.instance.addPostFrameCallback((_) => textController.clear());
                });
                _search("");
              },
            ) : null
        ),
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