import 'package:flutter/material.dart';

class Highlight extends StatelessWidget {
  Highlight({this.text, this.query, this.style1, this.style2});
  final String text;
  final String query;
  final TextStyle style1;
  final TextStyle style2;
  @override
  Widget build(BuildContext context) {
    if (query != '' && query != null) {
      List<TextSpan> result = [];
      List<String> arr = text.split(query);
      for (int i = 0; i < arr.length; i++) {
        if ((i % 2) == 1) {
          result.add(TextSpan(text: query, style: style2));
        }
        String v = arr[i];
        // print('v${v.length}');
        if (v != '' && v.length > 0) {
          result.add(TextSpan(text: v, style: style1));
        }
      }
      // print('result$result');
      return SelectableText.rich(
        TextSpan(children: result),
        scrollPhysics: NeverScrollableScrollPhysics(),
      );
    } else {
      return Text(
        text,
        style: style1,
      );
    }
  }
}
