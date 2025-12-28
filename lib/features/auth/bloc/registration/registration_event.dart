part of 'registration_bloc.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationEventRegistration extends RegistrationEvent {
  final Completer? completer;
  final String email;
  final String surname;
  final String name;
  final String password;

  RegistrationEventRegistration({required this.email, required this.surname, required this.name, required this.password, required this.completer});

  @override
  List<Object?> get props => [email, surname, name, password];
}

