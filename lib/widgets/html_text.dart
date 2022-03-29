import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:sakhatyla/home/home.dart';

class HtmlText extends StatelessWidget {
  static final RegExp wordRegExp = RegExp(r'[\p{Letter}\-]+', unicode: true);

  final String html;

  HtmlText(this.html);

  @override
  Widget build(BuildContext context) {
    var document = parse(html);
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: _convert(document, context),
      ),
    );
  }

  List<TextSpan> _convert(dom.Node node, BuildContext context) {
    final textSpans = <TextSpan>[];
    if (node.nodeType == dom.Node.TEXT_NODE) {
      final words = _splitText(node.text);
      for (var word in words) {
        textSpans.add(TextSpan(
          text: word,
          style: _getStyle(node),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _translate(word, context),
        ));
      }
    } else {
      textSpans.add(TextSpan(
        style: _getStyle(node),
        children: node.nodes.expand((n) => _convert(n, context)).toList(),
      ));
    }
    return textSpans;
  }

  List<String> _splitText(String? text) {
    final words = <String>[];
    if (text != null) {
      var start = 0;
      var isWord = false;
      for (var i = 0; i < text.length; i++) {
        if (text[i] == ' ') {
          isWord = false;
        } else {
          if (!isWord && i > start) {
            words.add(text.substring(start, i));
            start = i;
          }
          isWord = true;
        }
      }
      words.add(text.substring(start));
    }
    return words;
  }

  _translate(String word, BuildContext context) {
    final match = wordRegExp.firstMatch(word);
    if (match != null) {
      final result = match.group(0);
      if (result != null) {
        BlocProvider.of<HomeBloc>(context).add(Search(query: result));
        FocusScope.of(context).unfocus();
      }
    }
  }

  TextStyle? _getStyle(dom.Node node) {
    if (node is dom.Element) {
      FontWeight? fontWeight;
      FontStyle? fontStyle;
      if (node.localName == 'strong' || node.localName == 'b') {
        fontWeight = FontWeight.bold;
      } else if (node.localName == 'em' || node.localName == 'i') {
        fontStyle = FontStyle.italic;
      }
      return TextStyle(
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      );
    }
    return null;
  }
}
