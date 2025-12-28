part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthEventOauthGoogle extends AuthEvent {
  final Completer? completer;

  AuthEventOauthGoogle({required this.completer});

  @override
  List<Object?> get props => [completer];
}

class AuthEventLogin extends AuthEvent {
  final Completer? completer;
  final String email;
  final String password;

  AuthEventLogin({required this.completer, required this.email, required this.password});

  @override
  List<Object?> get props => [completer, email, password];
}

class AuthEventRefreshTokens extends AuthEvent {
  @override
  List<Object?> get props => [];
}
