import 'package:bloc/bloc.dart';
import 'package:contacts_app/repositories/user_profile/user_profile_repository.dart';
import 'package:contacts_app/repositories/water_drink/water_tracker_repository.dart';
import 'package:equatable/equatable.dart';

part 'health_widgets_event.dart';
part 'health_widgets_state.dart';

class HealthWidgetsBloc extends Bloc<HealthWidgetsEvent, HealthWidgetsState> {
  HealthWidgetsBloc({required this.waterTrackerRepository, required this.userProfileRepository}) : super(HealthWidgetsInitial()) {
    on<HealthWidgetsReadEvent>((event, emit) async {
      if(state is! HealthWidgetsLoaded) emit(HealthWidgetsLoading());

      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final dayTotal = await waterTrackerRepository.watchDayTotal(today).first; // берём первое значение стрима
      emit(HealthWidgetsLoaded(waterDrunk: dayTotal));
    });

    on<HealthWidgetsDrinkWaterEvent>((event, emit) async {
      await waterTrackerRepository.addWater(event.ml);

      // после добавления сразу обновляем (сегодняшний день)
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final dayTotal = await waterTrackerRepository.watchDayTotal(today).first;

      emit(HealthWidgetsLoaded(waterDrunk: dayTotal));
    });

    on<HealthWidgetsClearWaterEvent>((event, emit) async {
      if(state is HealthWidgetsLoaded) {
        await waterTrackerRepository.clearWater();
        int waterSum = await waterTrackerRepository.waterSum();
        emit(HealthWidgetsLoaded(waterDrunk: waterSum));
      }
    });
  
  }

  final WaterTrackerRepository waterTrackerRepository;
  final UserProfileRepository userProfileRepository;
}
