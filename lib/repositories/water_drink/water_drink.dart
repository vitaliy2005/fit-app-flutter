import 'package:isar_community/isar.dart';

part 'water_drink.g.dart';

@Collection()
class WaterDrink {
  Id id = Isar.autoIncrement;
  late int amount;
  late DateTime time;
  String? note;

  @Index()
  late int dayKey;
}