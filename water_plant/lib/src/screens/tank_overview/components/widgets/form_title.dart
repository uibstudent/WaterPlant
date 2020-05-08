import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  const FormTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
