import 'package:flutter/material.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:water_plant/src/screens/all_plants/components/all_plants_body.dart';

class AllPlantsScreen extends StatelessWidget {
  final List<WaterTankDevice> tanks;

  AllPlantsScreen(this.tanks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: Image.asset('assets/logo_white_background.png'),
        ),
        centerTitle: true,
      ),
      body: AllPlantsBody(tanks),
    );
  }
}
