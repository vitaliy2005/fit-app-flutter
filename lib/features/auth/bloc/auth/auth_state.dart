part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistration extends AuthState {}

class AuthRefreshTokens extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userEmail;
  final String userName;

  const AuthAuthenticated({
    required this.userEmail,
    required this.userName,
  });

  @override
  List<Object?> get props => [userEmail, userName];
}

class AuthFailure extends AuthState {
  final Object? errorMessage;

  const AuthFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}