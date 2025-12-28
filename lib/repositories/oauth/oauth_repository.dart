import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class OAuthRepositories {
  final _appAuth = FlutterAppAuth();
  final androidClientId = '983593064125-apdj9svf7skco423u345htd59hr2qmet.apps.googleusercontent.com';
  final redirectUri = 'com.example.contacts:/oauth2redirect';
  final backendBase = 'http://127.0.0.1:8000/google/auth/callback/android';

  final dio;

  OAuthRepositories({required this.dio});

  Future<Map<String, dynamic>> signIn() async {
    try {
      final AuthorizationResponse? authResult = await _appAuth.authorize(
        AuthorizationRequest(
          androidClientId,
          redirectUri,
          discoveryUrl:
          'https://accounts.google.com/.well-known/openid-configuration',
          scopes: ['openid', 'email', 'profile'],
          promptValues: ['consent'],
        ),
      );

      if (authResult != null) {
        print('Authorization code: ${authResult.authorizationCode}');
      } else {
        print('Authorization canceled or failed');
      }

      if (authResult == null ||
          authResult.authorizationCode == null ||
          authResult.codeVerifier == null) {
        throw Exception('Не удалось получить authorizationCode/codeVerifier');
      }

      final String code = authResult.authorizationCode!;
      final String codeVerifier = authResult.codeVerifier!;

      final response = await dio.post(
        backendBase,
        data: {
          'code': code,
          'code_verifier': codeVerifier,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Ошибка авторизации на сервере: ${response.statusCode} ${response.data}');
      }

      return response.data;
    } catch (e) {
      print("AUTH ERROR: $e");
      rethrow;
    }
  }
}
