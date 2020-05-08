import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/screens/tank_overview/components/edit_tank.dart';
import 'package:water_plant/src/screens/tank_overview/tank_overview.dart';
import 'package:water_plant/src/components/water_status.dart';
import 'package:water_plant/constants.dart' as Constants;

class OverviewBody extends StatefulWidget {
  final List<WaterTankDevice> tanks;
  OverviewBody(this.tanks);

  @override
  _OverviewBodyState createState() => _OverviewBodyState();
}

class _OverviewBodyState extends State<OverviewBody> {
  /// Refreshes the state of [_OverviewBodyState].
  ///
  /// Calling the function in another screen will update the state here.
  /// To send a function without calling it, you can do the following
  /// ```
  /// ... ExampleNewScreen(refresh); // Note how () is missing from refresh.
  /// ```
  refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Adds [tank] to [widget.tanks].
  ///
  /// Calling the function in another screen will update the state here.
  /// To send a function without calling it, you can do the following
  /// ```
  /// ... ExampleNewScreen(addTank); // Note how () is missing from addTank.
  /// ```
  addTank(WaterTankDevice tank) {
    assert(tank != null);
    setState(() {
      widget.tanks.add(tank);
    });
  }

  /// Removes the [tank] if it's in [widget.tanks].
  ///
  /// Calling the function in another screen will update the state here.
  /// To send a function without calling it, you can do the following
  /// ```
  /// ... ExampleNewScreen(removeTank); // Note how () is missing from removeTank.
  /// ```
  removeTank(WaterTankDevice tank) {
    assert(tank != null);
    setState(() {
      if (widget.tanks.contains(tank)) {
        widget.tanks.remove(tank);
      }
    });
  }

  _navigateAndDisplaySnackbar(BuildContext context, Function goToPage) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => goToPage(),
        ));

    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$result"),
          backgroundColor: Constants.CustomColors.WATER_LEVEL_FILL,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    for (WaterTankDevice t in widget.tanks) {
      for (Plant p in t.plants) {
        assert(p.plantTypeInfo != null);
      }
    }
    assert(widget.tanks != null);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: Image.asset('assets/logo_white_background.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _navigateAndDisplaySnackbar(
                context,
                () => EditTank(
                  addTank: addTank,
                  numberOfTanksConnectedToApp: widget.tanks.length,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    'Device  ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          widget.tanks.isEmpty
              ? Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Press the button in the top right to add a new device',
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 10, // space above the list of tank cards
                      ),
                      for (var tank in widget.tanks) tankOverviewCard(tank),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  /// Plants that have critical or low hydration (and is not currently being
  /// watered) needs watering.
  List<Plant> getPlantsThatNeedWatering(WaterTankDevice tank) {
    List<Plant> plantsThatNeedWatering = [];
    for (Plant plant in tank.plants) {
      assert(plant != null);
      if (!plant.isBeingWatered) {
        if (plant.isHydrationCritical() || plant.isHydrationLow()) {
          plantsThatNeedWatering.add(plant);
        }
      }
    }
    return plantsThatNeedWatering;
  }

  /// Shows an overview of a [WaterTankDevice]. Displays the water level in the
  /// tank, the name of the tank and the plants that belong to it that need watering.
  Widget tankOverviewCard(WaterTankDevice tank) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TankOverview(
              tank,
              callback: refresh,
              removeTank: removeTank,
              addTank: addTank,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 210,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5),
                child: RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '${tank.nickname} ',
                          style: TextStyle(fontSize: 30),
                        ),
                      ]),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: WaterStatus(tank.waterLevel)),
              Expanded(
                child: Container(
                  width: 300,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getPlantsThatNeedWatering(tank).isEmpty
                          ? [
                              Container(
                                alignment: Alignment(1, -0.3),
                                padding: EdgeInsets.only(left: 55),
                                child: Text(
                                  'No plants need watering',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ]
                          : getPlantsThatNeedWatering(tank)
                              .map((plant) => plantIcon(tank, plant))
                              .toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Waters the [widget.plant] until it reaches [Plant.idealHydration].
  Future asyncWaterPlant(WaterTankDevice tank, Plant plant) async {
    plant.isBeingWatered = true;
    while (plant.isBeingWatered && plant.hydration < plant.idealHydration) {
      await tank.water(plant);
      if (mounted) {
        setState(() {});
      }
    }
    plant.isBeingWatered = false;
  }

  /// Creates a clickable plant icon which contains a picture of the
  /// incoming [Plant] object. Clicking the icon results in watering the plant
  /// and the icon disappearing.
  Widget plantIcon(WaterTankDevice tank, Plant plant) {
    return Column(
      children: <Widget>[
        Container(
          width: 75,
          height: 75,
          child: GestureDetector(
            onTap: () {
              asyncWaterPlant(tank, plant);
              setState(() {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Watering ${plant.nickname}..."),
                    backgroundColor: Constants.CustomColors.WATER_LEVEL_FILL,
                    action: SnackBarAction(
                        textColor:
                            Constants.CustomColors.SNACKBAR_ACTION_LABEL_COLOR,
                        label: "Undo",
                        onPressed: () {
                          setState(() {
                            plant.isBeingWatered = false;
                          });
                        }),
                  ));
              });
            },
            child: plantInPicFrame(plant),
          ),
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              width: 75,
              height: 75,
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                '${plant.nickname}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              )),
        ),
      ],
    );
  }

  /// Helper method for [plantIcon].
  /// The picture representing the [plant] in the tank.
  ClipRRect plantInPicFrame(Plant plant) {
    assert(plant != null);
    return ClipRRect(
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: plant.chosenImageFile == null
                  ? Image.asset(
                      plant.plantTypeImage,
                    )
                  : Image.file(
                      plant.chosenImageFile,
                      cacheHeight: 75,
                      cacheWidth: 75,
                    ),
            ),
          ),
          plant.isHydrationCritical()
              ? Positioned(
                  child: ClipOval(
                    child: Container(
                      color: Colors.red,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          '!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
