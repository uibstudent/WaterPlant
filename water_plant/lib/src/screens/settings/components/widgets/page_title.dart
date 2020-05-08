import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(
    this.text, {
    Key key,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final String text;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
