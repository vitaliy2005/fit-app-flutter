part of 'profile_widgets_bloc.dart';

sealed class ProfileWidgetsEvent extends Equatable {
  const ProfileWidgetsEvent();
}

class ProfileWidgetsReadEvent extends ProfileWidgetsEvent {
  @override
  List<Object?> get props => [];
}


