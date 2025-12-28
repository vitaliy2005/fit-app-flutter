part of 'health_widgets_bloc.dart';

sealed class HealthWidgetsEvent extends Equatable {
  const HealthWidgetsEvent();
}

class HealthWidgetsReadEvent extends HealthWidgetsEvent {
  @override
  List<Object?> get props => [];
}

class HealthWidgetsDrinkWaterEvent extends HealthWidgetsEvent {
  final int ml;

  HealthWidgetsDrinkWaterEvent({required this.ml});

  @override
  List<Object?> get props => [];
}

class HealthWidgetsClearWaterEvent extends HealthWidgetsEvent {
  @override
  List<Object?> get props => [];
}
