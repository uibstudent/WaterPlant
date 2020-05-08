import 'package:flutter/material.dart';
import 'package:water_plant/constants.dart' as Constants;

class WaterStatus extends StatelessWidget {
  final double waterLevel;
  final double width;
  final double height;
  final double paddingWidth;

  WaterStatus(this.waterLevel,
      {this.width = 21.0, this.height = 55.0, this.paddingWidth = 4});

  List<Widget> createWaterStatusBars(BuildContext context) {
    List<Widget> bars = [];
    Color color;

    Color emptyColor = Constants.CustomColors.WATER_LEVEL_EMPTY;
    Color fillColor = Constants.CustomColors.WATER_LEVEL_FILL;
    for (var i = 0; i < 10; i++) {
      double hyd = waterLevel / 10;
      hyd > i ? color = fillColor : color = emptyColor;
      bars.add(
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: color,
            ),
            width: width,
            height: height,
          ),
        ),
      );
    }
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              for (var bar in createWaterStatusBars(context))
                Container(
                    padding:
                        EdgeInsets.fromLTRB(paddingWidth, 0, paddingWidth, 0),
                    child: bar),
            ],
          ),
        ],
      ),
    );
  }
}
