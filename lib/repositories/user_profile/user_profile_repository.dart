import 'package:contacts_app/repositories/user_profile/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';


class UserProfileRepository {

  final Isar isar;
  final Dio dio;
  final FlutterSecureStorage flutterSecureStorage;

  UserProfileRepository({required this.isar, required this.dio, required this.flutterSecureStorage});

  Future<void> deleteUser() async {
  try {
    final accessToken = await flutterSecureStorage.read(key: 'access_token');

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    final response = await dio.post(
      "http://10.241.77.248:8000/login/delete_user/",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      print("Пользователь успешно удалён");
      await flutterSecureStorage.delete(key: 'access_token');
      await flutterSecureStorage.delete(key: 'refresh_token');
    } else {
      print("Ошибка удаления: ${response.statusCode} ${response.data}");
    }
  } catch (e) {
    print("deleteUser error: $e");
    if (e is DioException) {
      print("Error details: ${e.response?.data}");
    }
  }
}

  Future<Map<String, String>> getUserInfo() async {
    final access_token = await flutterSecureStorage.read(key: 'access_token');

    if(access_token == null) throw Exception("Access token not found");

    try {
      Response response = await dio.get(
        "http://10.241.77.248:8000/login/user_info/",
        options: Options(headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        }),
      );
      print("${response.data}");
      _writeUserInfo(response.data["email"], response.data["surname"],response.data["name"]);
      return Map<String, String>.from(response.data);

    } catch (e) {
      print('GetIntList error: $e');
      if (e is DioException) {
        print('Error details: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> _writeUserInfo(String email, String surname, String name) async {
      await isar.writeTxn(() async {
      final uq = UserProfile()
        ..email = email
        ..surname = surname
        ..name = name;

    await isar.userProfiles.put(uq); // если put async — await, если sync — без await
  });
  }

Future<void> changeUserInfo(String surname, String name, String email, String? password) async {
  final accessToken = await flutterSecureStorage.read(key: 'access_token');

  if (accessToken == null) {
    throw Exception("Access token not found");
  }

  final Map<String, dynamic> newData = {
    "surname": surname,
    "name": name,
    "email": email,
    if (password != null && password.isNotEmpty) "password": password,
  };

  try {
    final response = await dio.post(
      "http://10.241.77.248:8000/login/change_user_info/",
      data: newData,
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      ),
    );

    _writeUserInfo(email, surname, name);

  } catch (e) {
    print("changeUserInfo error: $e");
    if (e is DioException) {
      print("Error details: ${e.response?.data}");
    }
    rethrow;
  }
}

Future<UserProfile?> getProfile() async {
    return await isar.userProfiles.get(0);
  }
}