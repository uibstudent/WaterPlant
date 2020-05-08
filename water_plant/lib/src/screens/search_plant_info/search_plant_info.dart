import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/constants.dart' as Constants;
import 'package:water_plant/src/screens/plant_information/plant_information.dart';

class SearchPlantInfoScreen extends StatelessWidget {
  final List<WaterTankDevice> tanks;

  SearchPlantInfoScreen(this.tanks) {
    for (WaterTankDevice tank in tanks) {
      assert(tank != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Plant> allPlantTypes = [];
    var a = Constants.ALL_PLANTS_INFORMATION;
    for (int i = 0; i < a.length; i++) {
      var plantTypeInfo = a[i];
      //var name = plantTypeInfo.values.where((element) => element['name']);
      Plant plant = Plant(0, plantTypeInfo: plantTypeInfo);
      allPlantTypes.add(plant);
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: Image.asset('assets/logo_white_background.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(allPlantTypes: allPlantTypes),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (Plant plant in allPlantTypes) createPlantCard(context, plant),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    String hintText,
    this.allPlantTypes,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  List<Plant> allPlantTypes;

  List<Plant> searchForPlants(String name) {
    List<Plant> found = [];
    for (Plant plant in allPlantTypes) {
      if (plant.plantTypeName.toLowerCase().contains(name.toLowerCase())) {
        found.add(plant);
      }
    }
    return found;
  }

  Widget displayPlants(BuildContext context, List<Plant> plants) {
    return ListView(
      children: <Widget>[
        for (Plant plant in plants) createPlantCard(context, plant),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Constants.CustomColors.BOTTOM_NAVIGATION_BAR_COLOR,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query == '') {
      return displayPlants(context, allPlantTypes);
    } else {
      List<Plant> foundPlants = searchForPlants(this.query);
      return displayPlants(context, foundPlants);
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Plant> foundPlants = searchForPlants(this.query);
    return displayPlants(context, foundPlants);
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        this.query.isNotEmpty
            ? Container(
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    this.query = '';
                  },
                ),
              )
            : Container(),
      ];
}

/// Creates a card that contains information about the plant given to it.
/// Displays a picture of the [plant] using [Plant.plantTypeImage]. Also
/// shows the name of it in Latin and English. Clicking on the card shows
/// further information about the plant.
Widget createPlantCard(BuildContext context, Plant plant) {
  return Container(
    padding: EdgeInsets.only(top: 2, bottom: 2),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return PlantInformationScreen(plant);
            },
          ),
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              Image.asset(plant.plantTypeImage),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              plant.nickname != ''
                                  ? plant.nickname
                                  : plant.plantTypeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${plant.plantTypeLatinName}',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
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
