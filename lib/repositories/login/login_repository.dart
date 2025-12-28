
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginRepository {
  final Dio dio;
  final FlutterSecureStorage flutterSecureStorage;

  LoginRepository({required this.dio, required this.flutterSecureStorage});

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    if((email.length == 0) || (password.length == 0)) return {'jopa': 'jopa'};
    final data_account = {"username": email, "password": password};
    final response = await dio.post(
      "http://10.241.77.248:8000/login/",
      data: data_account,
      options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> refreshTokens() async {
    try {
      final refresh_token = await flutterSecureStorage.read(key: "refresh_token");

      if (refresh_token == null) {
        throw Exception("Refresh token not found");
      }

      final data_refresh_token = {"refresh_token": refresh_token};
      final response = await dio.post(
        "http://10.241.77.248:8000/login/refresh_tokens/",
        data: data_refresh_token,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data;

    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> registration(String email, String surname, String name, String password) async {
    try {
      final data_registration = {
        "email": email,
        "surname": surname,
        "name": name,
        "password": password,
        "picture": null
      };

      final response = await dio.post(
        "http://10.241.77.248:8000/registration/",
        data: data_registration,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}