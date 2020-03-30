import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class HtmlText extends StatelessWidget {
  final String html;

  HtmlText(this.html);

  @override
  Widget build(BuildContext context) {
    var document = parse(html);
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          _convert(document)
        ]
      )
    );
  }

  TextSpan _convert(dom.Node node) {
    return TextSpan(
      text: node.nodeType == dom.Node.TEXT_NODE ? node.text : null,
      style: _getStyle(node),
      children: node.nodes.map((n) => _convert(n)).toList()
    );
  }

  TextStyle _getStyle(dom.Node node) {
    if (node is dom.Element) {
      FontWeight fontWeight;
      FontStyle fontStyle;
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