import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/src/components/plant_info_card.dart';

/// A list overview of every single plant owned.
class AllPlantsBody extends StatefulWidget {
  final List<WaterTankDevice> tanks;

  AllPlantsBody(this.tanks);

  @override
  _PlantsOverviewScreenStateBody createState() =>
      _PlantsOverviewScreenStateBody();
}

class _PlantsOverviewScreenStateBody extends State<AllPlantsBody>
    with AutomaticKeepAliveClientMixin {
  refreshState() {
    if (mounted) {
      setState(() {});
    }
  }

  //Sort by plant hydration. Returns a map of Plant and its WaterTankDevice.
  sortMap(Map<Plant, WaterTankDevice> map) {
    var sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => k1.hydration.compareTo(k2.hydration));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => map[k]);

    return sortedMap;
  }

  /// In order to keep the screen updating if there is one or more plant(s)
  /// being watered.
  bool keepAlive = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Map<Plant, WaterTankDevice> tankPlantMap = {};
    for (WaterTankDevice tank in widget.tanks) {
      for (Plant plant in tank.plants) {
        tankPlantMap[plant] = tank;
      }
    }
    var sortedMap = sortMap(tankPlantMap);

    return Container(
      child: ListView(
        children: <Widget>[
          for (var entry in sortedMap.entries)
            PlantInfoCard(
              context: context,
              plant: entry.key,
              tank: entry.value,
              callback: refreshState,
              showHydrationMessage: true,
            ),
        ],
      ),
    );
  }

  /// Returns a list of every plant that is being watered (Every plant that
  /// has [Plant.isBeingWatered] set to true).
  List<Plant> allPlantsBeingWatered() {
    List<Plant> allPlantsBeingWatered = [];
    for (WaterTankDevice tank in widget.tanks) {
      for (Plant plant in tank.plants) {
        if (plant.isBeingWatered) {
          allPlantsBeingWatered.add(plant);
        }
      }
    }
    return allPlantsBeingWatered;
  }

  /// Update the critical/low/optimal/high soil moisture status graphically
  /// for the user while a plant is being watered.
  refreshSoilMoisture() async {
    keepAlive = true;
    updateKeepAlive();

    while (allPlantsBeingWatered().isNotEmpty) {
      await Future.delayed(Duration(seconds: 1)).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    keepAlive = false;
    updateKeepAlive();
  }

  @override
  void initState() {
    super.initState();
    refreshSoilMoisture();
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
