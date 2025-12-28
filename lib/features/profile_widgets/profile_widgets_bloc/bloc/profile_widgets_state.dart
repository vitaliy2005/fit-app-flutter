part of 'profile_widgets_bloc.dart';

sealed class ProfileWidgetsState extends Equatable {
  const ProfileWidgetsState();
}

class ProfileWidgetsInitial extends ProfileWidgetsState {
  @override
  List<Object?> get props => [];
}

class ProfileWidgetsLoading extends ProfileWidgetsState {
  @override
  List<Object?> get props => [];
}

class ProfileWidgetsLoaded extends ProfileWidgetsState {
  final String surname;
  final String name;
  final String userId;
  final String email;
  final String number;
  final String avatarUrl;

  ProfileWidgetsLoaded({
    required this.surname,
    required this.name, 
    required this.userId,
    required this.email,
    required this.number,
    required this.avatarUrl
  });

  @override
  List<Object?> get props => [surname, name, userId, email, number, avatarUrl];
}

class ProfileWidgetsError extends ProfileWidgetsState {
  final String message;
  const ProfileWidgetsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileWidgetsUnauthorized extends ProfileWidgetsState {
   @override
  List<Object?> get props => [];
}
