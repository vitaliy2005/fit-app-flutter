import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/repositories/login/login_repository.dart';
import 'package:contacts_app/repositories/oauth/oauth_repository.dart';
import 'package:contacts_app/repositories/user_profile/user_profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({required this.oauthRepositories, required this.loginRepository, required this.flutterSecureStorage, required this.userProfileRepository}) : super(AuthInitial()) {
   on<AuthEventRefreshTokens>((event, emit) async {
  print('<<< AuthEventRefreshTokens — начинаем обновление токенов');

  try {
    emit(AuthRefreshTokens()); // индикатор обновления (по желанию)

    final data = await loginRepository.refreshTokens();
    print('✓ Refresh успешен: $data');

    await flutterSecureStorage.write(key: "access_token", value: data['access_token']);
    await flutterSecureStorage.write(key: "refresh_token", value: data['refresh_token']);

    // Возвращаем аутентифицированное состояние (очень важно!)
    emit(AuthAuthenticated(
      userEmail: state is AuthAuthenticated ? (state as AuthAuthenticated).userEmail : "userEmail",
      userName: state is AuthAuthenticated ? (state as AuthAuthenticated).userName : "userName",
    ));

    await _UpdateTokens(); // пересоздаём таймер с новым exp
  } catch (e, stackTrace) {
    print('✗ ОШИБКА ОБНОВЛЕНИЯ ТОКЕНОВ: $e');
    print(stackTrace);
  }
});
    on<AuthEventOauthGoogle>((event, emit) async {
      try {
        if(state is! AuthAuthenticated) {
          emit(AuthLoading());
        }
        final Map<String, dynamic> data_json = await oauthRepositories.signIn();

        emit(AuthAuthenticated(userEmail: "userEmail", userName: "userName"));
      } catch (e) {
        emit(AuthFailure(errorMessage: e));
      } finally {}
    });

    on<AuthEventLogin>((event, emit) async {
      try {
        if(state is! AuthAuthenticated) {
          emit(AuthLoading());
        }
        final Map<String, dynamic> data_json = await loginRepository.logIn(event.email, event.password);
        await flutterSecureStorage.write(key: "access_token", value: data_json['access_token']);
        await flutterSecureStorage.write(key: "refresh_token", value: data_json['refresh_token']);
        userProfileRepository.getUserInfo();
        emit(AuthAuthenticated(userEmail: "userEmail", userName: "userName"));
        await _UpdateTokens();
      } catch (e){
        emit(AuthFailure(errorMessage: e));
      } finally {}
    });
  }

  Future<void> _UpdateTokens() async {
    timerUpdateTokens?.cancel();

    String access_token = await flutterSecureStorage.read(key: "access_token") as String;

    final expires_time = JwtDecoder.decode(access_token)["exp"] as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final ttl = expires_time - now;

    final refreshIn = ttl > 30 ? ttl - 30 : 0;
    print(refreshIn);
    timerUpdateTokens = Timer(Duration(seconds: refreshIn), () {
  if (!isClosed) {
    print('>>> Вызываем refresh tokens из таймера');
    add(AuthEventRefreshTokens()); // ← прямо здесь
  }
});
  }

  @override
  Future<void> close() {
    print("AuthBloc closing — теряем таймер?");
    timerUpdateTokens?.cancel();
    return super.close();
  }

  final OAuthRepositories oauthRepositories;
  final LoginRepository loginRepository;
  final UserProfileRepository userProfileRepository;
  final FlutterSecureStorage flutterSecureStorage;
  Timer? timerUpdateTokens;
}
