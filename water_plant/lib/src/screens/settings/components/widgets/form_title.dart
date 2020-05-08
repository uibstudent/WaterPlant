import 'package:flutter/material.dart';

Container formTitle(String text) {
  return Container(
    padding: EdgeInsets.only(left: 15),
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
