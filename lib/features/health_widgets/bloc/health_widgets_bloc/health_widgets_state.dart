part of 'health_widgets_bloc.dart';

sealed class HealthWidgetsState extends Equatable {
  const HealthWidgetsState();
}

class HealthWidgetsInitial extends HealthWidgetsState {
  @override
  List<Object> get props => [];
}

class HealthWidgetsLoading extends HealthWidgetsState {
  @override
  List<Object?> get props => [];
}

class HealthWidgetsLoaded extends HealthWidgetsState {
  final int waterDrunk;
  HealthWidgetsLoaded({required this.waterDrunk});

  @override
  List<Object?> get props => [waterDrunk];
}