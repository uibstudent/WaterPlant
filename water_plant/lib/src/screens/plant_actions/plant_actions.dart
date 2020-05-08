import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/screens/plant_actions/components/plant_actions_body.dart';
import 'package:water_plant/src/screens/tank_overview/components/edit_plant.dart';
import 'package:water_plant/constants.dart' as Constants;

/// A screen that shows the hydration level of a [Plant], and gives you
/// the possibility to water the plant by clicking a button.
class PlantActionsScreen extends StatefulWidget {
  final Plant plant;
  final WaterTankDevice tank;
  final Function callback;

  PlantActionsScreen(
      {@required this.plant, @required this.tank, @required this.callback});

  @override
  _PlantActionsScreenState createState() => _PlantActionsScreenState();
}

class _PlantActionsScreenState extends State<PlantActionsScreen> {
  refreshState() {
    if (mounted) {
      setState(() {});
    }
    widget.callback();
  }

  /// Navigates to [goToPage] and displays a snackbar with [result] from that
  /// page when [Navigator.pop(context, result)] is called in that page.
  _navigateAndDisplaySnackbar(BuildContext context, Function goToPage) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => goToPage(),
        ));

    // goToPage has called Navigator.pop()

    if (result != null) {
      String actionHappened = result[0];

      if (actionHappened == 'Remove') {
        int deletedPlantPipe = result[1];
        Plant deletedPlant = result[2];
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Removed plant ${deletedPlant.nickname}'),
              backgroundColor: Constants.CustomColors.WATER_LEVEL_FILL,
              action: SnackBarAction(
                label: 'Undo',
                textColor: Constants.CustomColors.SNACKBAR_ACTION_LABEL_COLOR,
                onPressed: () {
                  widget.tank.addPlant(deletedPlantPipe, deletedPlant);
                  refreshState();
                },
              ),
            ),
          );
      } else if (actionHappened == 'Edit') {
        //Plant plant = result[1];

        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Changes saved'),
              backgroundColor: Constants.CustomColors.WATER_LEVEL_FILL,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                () => EditPlant(
                  widget.tank,
                  widget.plant,
                  refreshState,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.edit,
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset:
          false, // to avoid screen being squeezed together when editing name
      body: PlantInfoBody(
          plant: widget.plant, tank: widget.tank, callback: refreshState),
    );
  }
}
