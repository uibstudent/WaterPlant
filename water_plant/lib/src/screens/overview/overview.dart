import 'package:custom_navigator/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/screens/overview/components/overview_body.dart';
import 'package:water_plant/src/screens/all_plants/all_plants.dart';
import 'package:water_plant/src/screens/search_plant_info/search_plant_info.dart';
import 'package:water_plant/src/screens/settings/settings_screen.dart';
import 'package:water_plant/constants.dart' as Constants;

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<WaterTankDevice> tanks = [];
  int _currentIndex = 0;

  //GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Plant> createPlants() {
    List<String> plantNames = [
      'Chinese Evergreen',
      'Emerald Palm',
      'Orchid',
      'Yucca Palm'
    ];
    List<int> hydrationLevels = [
      0,
      0,
      0,
      0,
    ];
    List<Plant> plants = [];
    for (int i = 0; i < plantNames.length; i++) {
      var plantTypeInfo = Constants.ALL_PLANTS_INFORMATION[i];
      assert(plantTypeInfo != null);

      Plant plant = Plant(hydrationLevels[i],
          nickname: plantNames[i], plantTypeInfo: plantTypeInfo);
      plants.add(plant);
    }
    return plants;
  }

  bool hasAdded = false;

  @override
  Widget build(BuildContext context) {
    if (!hasAdded) {
      //var tankNames = ['Living Room', 'Kitchen', 'Bathroom'];
      var tankNames = ['Kitchen'];

      for (int i = 0; i < tankNames.length; i++) {
        var tank = WaterTankDevice(tankNames[i]);

        var plants = createPlants();
        for (int i = 0; i < Constants.ALLOWED_NUMBER_OF_PLANTS_IN_TANK; i++) {
          tank.addPlant(i + 1, plants[i]);
        }
        tanks.add(tank);
      }
      hasAdded = true;
    }

    var _pages = [
      OverviewBody(tanks),
      AllPlantsScreen(tanks),
      SearchPlantInfoScreen(tanks),
      SettingsScreen(),
    ];

    return CustomScaffold(
      scaffold: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Constants.CustomColors.BOTTOM_NAVIGATION_BAR_COLOR,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (int index) {},
          items: _items,
        ),
      ),
      children: _pages,
      onItemTap: (index) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
      },
    );
  }
}

double _iconSize = 25.0;
final _items = [
  BottomNavigationBarItem(
    icon: Container(
      child: ImageIcon(
        AssetImage(
          'assets/logo_white_transparent.png',
        ),
        size: _iconSize,
      ),
    ),
    title: Text('Overview'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.view_list,
      size: _iconSize,
    ),
    title: Text('Plants'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.info_outline,
      size: _iconSize,
    ),
    title: Text('Plant Info'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.settings,
      size: _iconSize,
    ),
    title: Text('Settings'),
  ),
];
