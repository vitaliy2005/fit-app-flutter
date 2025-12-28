part of 'registration_bloc.dart';

sealed class RegistrationState extends Equatable {
  const RegistrationState();
}

final class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => [];
}

final class RegistrationLoading extends RegistrationState {
  @override
  List<Object> get props => [];
}

final class RegistrationSuccess extends RegistrationState {
  @override
  List<Object> get props => [];
}

final class RegistrationFailure extends RegistrationState {
  final Object? errorMessage;

  RegistrationFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
