import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';

class PlantSoilMoisturePercentage extends StatelessWidget {
  const PlantSoilMoisturePercentage({
    Key key,
    @required this.plant,
    this.spaceBeforeText = false,
  }) : super(key: key);

  final Plant plant;
  final bool spaceBeforeText;

  @override
  Widget build(BuildContext context) {
    String space = '';
    if (spaceBeforeText) {
      space = '    ';
    }
    return Container(
      child: Stack(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: space + 'Soil moisture: ',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${plant.hydration}%    ',
                  style: TextStyle(
                    color: plant.isHydrationCritical()
                        ? Colors.red
                        : Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          plant.isHydrationCritical()
              ? Positioned(
                  top: 4,
                  right: 0,
                  child: ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: 15,
                      height: 15,
                      child: Center(
                        child: Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 4,
                  right: 0,
                  child: Container(),
                ),
        ],
      ),
    );
  }
}
