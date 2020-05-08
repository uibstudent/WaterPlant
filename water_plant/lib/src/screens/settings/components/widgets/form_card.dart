import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  const FormCard({
    Key key,
    this.bottomPadding = 20,
    this.topPadding = 0,
    this.elevation = 5,
    this.height = 48,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final double bottomPadding;
  final double topPadding;
  final double elevation;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: bottomPadding,
        top: topPadding,
      ),
      elevation: elevation,
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.only(
          left: 12,
        ),
        color: Colors.white,
        child: child,
      ),
    );
  }
}
