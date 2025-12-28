import 'package:isar_community/isar.dart';
import 'package:contacts_app/repositories/water_drink/water_drink.dart';


class WaterTrackerRepository {
  final Isar isar;

  WaterTrackerRepository({required this.isar});

  Future<void> addWater(int ml, {DateTime? at, String? note}) async {
  final now = at ?? DateTime.now();

  await isar.writeTxn(() async {
    final wd = WaterDrink()
      ..amount = ml
      ..time = now
      ..dayKey = dayKeyFromDate(now)
      ..note = note;

    await isar.waterDrinks.put(wd); // если put async — await, если sync — без await
  });

  final sum = await waterSum();
  if (sum >= 10000) {
    await clearWater(); // отдельная транзакция, короткая
  }
}

  Future<void> deleteWater(int id) async {
    return await isar.writeTxn(() => isar.waterDrinks.delete(id));
  }

  Future<int> waterSum() async {
    return await isar.waterDrinks.where().amountProperty().sum();
  }

  Future<void> clearWater() async {
    await isar.writeTxn(() async => await isar.clear());
  }

  int dayKeyFromDate(DateTime dt) {
    final d = DateTime(dt.year, dt.month, dt.day);
    return d.year * 10000 + d.month * 100 + d.day;
  }

  Future<void> updateDrink(WaterDrink d) async {
    d.dayKey = dayKeyFromDate(d.time);
    await isar.writeTxn(() => isar.waterDrinks.put(d));
  }

  /// Список всех записей за конкретный день
  Stream<List<WaterDrink>> watchDayDrinks(DateTime dayLocal) {
    final key = dayKeyFromDate(dayLocal);
    return isar.waterDrinks.filter().dayKeyEqualTo(key).sortByTimeDesc().watch(fireImmediately: true);
  }

  /// Итоговое кол-во мл за день (реактивно)
  Stream<int> watchDayTotal(DateTime dayLocal) {
    return watchDayDrinks(dayLocal).map((list) => list.fold<int>(0, (s, e) => s + e.amount));
  }
}