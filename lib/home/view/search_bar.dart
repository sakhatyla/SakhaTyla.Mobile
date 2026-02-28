import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/utils/debouncer.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchBar extends StatefulWidget {
  final String? query;
  final bool showSakhaLetters;

  SearchBar({this.query, this.showSakhaLetters = false});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final textController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 200);
  @override
  void initState() {
    super.initState();

    textController.text = widget.query ?? '';
  }

  onLetterPress(String value) {
    setState(() {
      this.textController.text += value;
      var cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: textController.text.length));
      textController.selection = cursorPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final letterButtonWidth = MediaQuery.of(context).size.width / 8;
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        setState(() {
          if (state is HomeLoading) {
            textController.text = state.query;
          }
        });
      },
      child: Column(
        children: [
          TextField(
            controller: textController,
            onTap: () {
              BlocProvider.of<HomeBloc>(context).add(LastQuery());
            },
            onSubmitted: _search,
            onChanged: (text) {
              setState(() {});
              _debouncer.run(() =>
                  BlocProvider.of<HomeBloc>(context).add(Suggest(query: text)));
            },
            decoration: InputDecoration(
                hintText: 'Введите текст',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                suffixIcon: textController.text.length > 0 ||
                        BlocProvider.of<HomeBloc>(context).state is HomeHistory
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            // https://github.com/flutter/flutter/issues/17647
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => textController.clear());
                          });
                          _search("");
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.keyboard),
                        onPressed: _openKeyboardUrl,
                      )),
          ),
          if (this.widget.showSakhaLetters)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: letterButtonWidth,
                    height: letterButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        this.onLetterPress('ҥ');
                      },
                      child: Text('ҥ', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: letterButtonWidth,
                    height: letterButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        this.onLetterPress('ҕ');
                      },
                      child: Text('ҕ', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: letterButtonWidth,
                    height: letterButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        this.onLetterPress('ө');
                      },
                      child: Text('ө', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: letterButtonWidth,
                    height: letterButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        this.onLetterPress('һ');
                      },
                      child: Text('һ', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: letterButtonWidth,
                    height: letterButtonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        this.onLetterPress('ү');
                      },
                      child: Text('ү', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  _search(String text) {
    _debouncer.cancel();
    BlocProvider.of<HomeBloc>(context).add(Search(query: text));
  }

  _openKeyboardUrl() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'https://sakhatyla.ru/pages/keyboard-android';
    } else if (Platform.isIOS) {
      url = 'https://sakhatyla.ru/pages/keyboard-ios';
    }

    if (url != '') {
      await launchUrl(Uri.parse(url));
    }
  }
}
