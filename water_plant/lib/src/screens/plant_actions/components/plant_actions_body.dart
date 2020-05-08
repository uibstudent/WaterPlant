import 'package:flutter/material.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/components/plant_soil_moisture_text.dart';
import 'package:water_plant/src/screens/plant_information/plant_information.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/src/components/water_status.dart';
import 'package:water_plant/constants.dart' as Constants;

import 'dart:math';

class PlantInfoBody extends StatefulWidget {
  final Plant plant;
  final WaterTankDevice tank;
  final Function callback;

  PlantInfoBody(
      {Key key,
      @required this.plant,
      @required this.tank,
      @required this.callback})
      : super(key: key);

  @override
  _PlantInfoBodyState createState() => _PlantInfoBodyState();
}

class _PlantInfoBodyState extends State<PlantInfoBody>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool automaticWatering = widget.plant.isAutomaticWateringActive();
    return Container(
      child: Column(
        children: <Widget>[
          PlantNameAndInfoButton(widget: widget),
          Expanded(
            flex: 4,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return PlantInformationScreen(widget.plant);
                      },
                    ),
                  );
                },
                child: PlantPicture(widget: widget),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              constraints: BoxConstraints.loose(
                Size.fromWidth(300),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Auto:',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Checkbox(
                            value: automaticWatering,
                            onChanged: (bool value) {
                              setState(() {
                                widget.plant.automaticWatering = value;
                              });
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: PlantSoilMoisturePercentage(
                              plant: widget.plant,
                              spaceBeforeText: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        //top: 10,
                        bottom: 10,
                      ),
                      child: widget.plant.isBeingWatered
                          ? Container(
                              child: LinearProgressIndicator(
                                backgroundColor: Constants
                                    .CustomColors.SCAFFOLD_BACKGROUND_COLOR,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Constants.CustomColors.WATER_LEVEL_FILL),
                              ),
                            )
                          : Container(
                              child: LinearProgressIndicator(
                                backgroundColor: Constants
                                    .CustomColors.SCAFFOLD_BACKGROUND_COLOR,
                                value: 0,
                              ),
                            ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Device: ${widget.tank.nickname} [Pipe ${widget.tank.pipeConnections[widget.plant]}]',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      child: WaterStatus(
                        widget.tank.waterLevel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Transform.rotate(
                  angle: pi / 4.0,
                  child: waterButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A button that controls watering the [widget.plant].
  ///
  /// Toggles [widget.tank] to start/stop watering the [widget.plant] when
  /// pressing the button.
  /// Displays [_waterButton()] when this plant is not currently being watered.
  /// Dispays [_waterButtonCancel()] when this plant is being watered.
  Widget waterButton() {
    Widget _currentWaterButton;
    setState(() {
      _currentWaterButton =
          widget.plant.isBeingWatered ? _waterButtonStop() : _waterButton();
    });
    return Container(
      child: _currentWaterButton,
    );
  }

  GestureDetector _waterButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          widget.plant.isBeingWatered = true;
        });
        asyncWaterPlant();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Constants.CustomColors.BORDER_COLOR,
              width: 2,
            )),
        child: Transform.rotate(
          angle: -pi / 2.0,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              'assets/water_plant_button_image.png',
              semanticLabel:
                  'Button that tells your device to water this plant',
              scale: 3,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _waterButtonStop() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.plant.isBeingWatered = false;
        });
        widget.callback();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Constants.CustomColors.BORDER_COLOR,
              width: 2,
            )),
        child: Transform.rotate(
          angle: -pi / 4.0,
          child: Container(
            width: 63,
            height: 63,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: Text(
              'Stop',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Waters the [widget.plant] until it reaches [Plant.idealHydration].
  Future asyncWaterPlant() async {
    keepAlive = true;
    updateKeepAlive();

    widget.plant.isBeingWatered = true;

    while (widget.plant.isBeingWatered &&
        widget.plant.hydration < widget.plant.idealHydration) {
      await widget.tank.water(widget.plant);
      if (mounted) {
        setState(() {});
      }
      widget.callback();
    }

    widget.plant.isBeingWatered = false;

    keepAlive = false;
    updateKeepAlive();
  }

  @override
  bool get wantKeepAlive {
    return keepAlive;
  }

  /// This method will make sure that the soil moisture will be
  /// graphically updated for the user when navigating back to this screen.

  /// Navigating away from this screen while watering the plant would normally
  /// cause the soil moisture from updating when going back to this screen (it
  /// gets un-mounted and so calling [setState] won't work).
  /// By using [AutomaticKeepAliveClientMixin], the soil moisture can still be
  /// updated.
  refreshSoilMoisture() async {
    keepAlive = true;
    updateKeepAlive();

    while (widget.plant.isBeingWatered &&
        widget.plant.hydration < widget.plant.idealHydration) {
      await Future.delayed(Duration(seconds: 1)).then((value) {
        if (mounted) {
          setState(() {});
        }
        widget.callback();
      });

      if (widget.plant.hydration >= widget.plant.idealHydration) {
        widget.plant.isBeingWatered = false;
        if (mounted) {
          setState(() {});
        }
      }
    }

    keepAlive = false;
    updateKeepAlive();
  }

  @override
  void initState() {
    super.initState();
    keepAlive = true;
    updateKeepAlive();

    refreshSoilMoisture();

    keepAlive = false;
    updateKeepAlive();
  }
}

class PlantNameAndInfoButton extends StatelessWidget {
  const PlantNameAndInfoButton({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PlantInfoBody widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.info,
            color: Constants.CustomColors.LIGHT_GREEN_COLOR,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return PlantInformationScreen(widget.plant);
                },
              ),
            );
          },
          iconSize: 30,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: 20,
            bottom: 20,
            right: 47,
          ),
          child: Text(
            '${widget.plant.nickname}',
            style: TextStyle(
              fontSize: 30,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class PlantPicture extends StatelessWidget {
  const PlantPicture({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PlantInfoBody widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Hero(
        tag: widget.plant.chosenImageFile == null
            ? widget.plant.plantTypeImage
            : widget.plant.chosenImageFile,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: Constants.CustomColors.BORDER_COLOR,
              width: 2,
            ),
          ),
          child: ClipRRect(
            child: Container(
              child: widget.plant.chosenImageFile == null
                  ? Image.asset(widget.plant.plantTypeImage)
                  : Image.file(
                      widget.plant.chosenImageFile,
                      cacheHeight: 200,
                      cacheWidth: 200,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
