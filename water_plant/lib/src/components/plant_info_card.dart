import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/components/plant_soil_moisture_text.dart';
import 'package:water_plant/src/screens/plant_actions/plant_actions.dart';

class PlantInfoCard extends StatelessWidget {
  PlantInfoCard({
    @required this.context,
    @required this.plant,
    @required this.tank,
    @required this.callback,
    this.showHydrationMessage = false,
  });

  final BuildContext context;
  final Plant plant;
  final WaterTankDevice tank;
  final Function callback;
  final bool showHydrationMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantActionsScreen(
                  plant: plant, tank: tank, callback: callback),
            ),
          );
        },
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(0),
            height: 80,
            child: Row(
              children: <Widget>[
                plant.chosenImageFile == null
                    ? Image.asset(plant.plantTypeImage)
                    : Image.file(
                        plant.chosenImageFile,
                        cacheHeight: 80,
                        cacheWidth: 80,
                      ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                plant.nickname,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: showHydrationMessage
                              ? Container(
                                  child: PlantSoilMoistureMessage(plant: plant),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: PlantSoilMoisturePercentage(
                                    plant: plant,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlantSoilMoistureMessage extends StatelessWidget {
  const PlantSoilMoistureMessage({
    Key key,
    this.showMessageStatus = true,
    @required this.plant,
    this.spaceBeforeText = false,
  }) : super(key: key);

  final Plant plant;
  final bool spaceBeforeText;

  final bool showMessageStatus;

  @override
  Widget build(BuildContext context) {
    String space = '';
    if (spaceBeforeText) {
      space = '    ';
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  text: '${plant.hydrationStatus()} ',
                  style: TextStyle(
                    color: plant.isHydrationCritical()
                        ? Colors.red
                        : Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          plant.isHydrationCritical()
              ? ClipOval(
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
                )
              : Container(),
        ],
      ),
    );
  }
}
