/// Both [Plant] and [WaterTankDevice] need to have a name.
/// By using this interface, we can make sure that we can't put objects that
/// don't have a name field into certain functions.
class IPlantAndWaterTank {
  String nickname;
}
