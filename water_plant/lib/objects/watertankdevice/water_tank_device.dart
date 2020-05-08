import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/constants.dart' as Constants;
import '../IPlantAndWaterTank.dart';

/// This device can have up to four [Plant]s. It keeps track of the water level
/// of the tank, as well as which plants belong to the device.
class WaterTankDevice implements IPlantAndWaterTank {
  /// The name of this tank.
  String nickname;

  /// How much water is in this tank.
  double waterLevel;

  /// Keeps track of which plant each pipe goes to.
  ///
  /// There are 4 pipes one the device, and the pipes are numbered from
  /// 1 to 4. pipeConnections[plant] = 1
  /// means that the first pipe is connected to that plant object.
  /// 2 is second pipe, and so on.
  Map<Plant, int> _pipeConnections;

  WaterTankDevice(this.nickname, {this.waterLevel = 100}) {
    _pipeConnections = <Plant, int>{};
  }

  List<Plant> plantsBeingWatered() {
    List<Plant> plantsBeingWatered = [];
    for (Plant plant in plants) {
      if (plant.isBeingWatered) {
        plantsBeingWatered.add(plant);
      }
    }
    return plantsBeingWatered;
  }

  /// Add [plant] to this device, and set it to be connected to [pipe].
  void addPlant(int pipe, Plant plant) {
    assert(plant != null);
    assert(pipe >= 1 && pipe <= 4);
    assert(!_pipeConnections.containsValue(pipe));
    if (this._pipeConnections.length <
        Constants.ALLOWED_NUMBER_OF_PLANTS_IN_TANK) {
      _pipeConnections[plant] = pipe;
    }
  }

  bool removePlant(Plant plant) {
    assert(plant != null);
    if (_pipeConnections.containsKey(plant)) {
      _pipeConnections.remove(plant);
      return true;
    }
    return false;
  }

  bool isEveryPlantAboveLowWaterLevel() {
    for (Plant p in _pipeConnections.keys) {
      if (p.isHydrationLow() || p.isHydrationCritical()) {
        return false;
      }
    }
    return true;
  }

  /// Water [plant] for a small amount.
  ///
  /// This function is typically called until [plant.waterLevel] has reached
  /// [plant.idealHydration] and while [plant.isBeingWatered] is true.
  /// One should update [plant.isBeingWatered] accordingly when watering
  /// the [plant].
  /// An example of its use:
  /// ```
  /// plant.isBeingWatered = true;
  ///  while (plant.isBeingWatered && plant.hydration < plant.idealHydration) {
  ///   await tank.water(plant);
  ///   if (mounted) {
  ///     setState(() {});
  ///   }
  ///  }
  /// plant.isBeingWatered = false;
  /// ```
  /// In the code example above, calling [setState] will update the use of
  /// [plant.waterLevel] in the class [setState] is being called in.
  Future<void> water(Plant plant) async {
    assert(plant != null);
    await Future.delayed(Duration(seconds: 1))
        .then((value) => plant.hydration += 1);
    if (waterLevel > 0.5) {
      waterLevel -= 0.2;
    }
  }

  /// Get the pipe that [plant] is connected to in this tank.
  int pipeConnectedTo(Plant plant) {
    assert(plant != null);
    assert(pipeConnections.containsKey(plant));
    return pipeConnections[plant];
  }

  /// Get all pipes that are not connected to any [Plant]s.
  List<int> availablePipes() {
    List<int> pipes = [1, 2, 3, 4];
    for (int pipe in _pipeConnections.values) {
      pipes.remove(pipe);
    }
    return pipes;
  }

  Map<Plant, int> get pipeConnections {
    return this._pipeConnections;
  }

  /// Returns a sorted list of the [Plant]s in this tank.
  List<Plant> get plants {
    List<Plant> plants = [];
    for (Plant plant in _pipeConnections.keys) {
      plants.add(plant);
    }
    plants.sort((a, b) => a.hydration.compareTo(b.hydration));
    return plants;
  }
}
