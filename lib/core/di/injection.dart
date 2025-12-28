import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:contacts_app/features/profile_widgets/profile_widgets_bloc/bloc/profile_widgets_bloc.dart';
import 'package:contacts_app/repositories/user_profile/user_profile.dart';
import 'package:contacts_app/repositories/user_profile/user_profile_repository.dart';
import 'package:contacts_app/repositories/water_drink/water_drink.dart';
import 'package:contacts_app/repositories/water_drink/water_tracker_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar_community/isar.dart';

import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:contacts_app/repositories/login/login_repository.dart';
import 'package:contacts_app/repositories/oauth/oauth_repository.dart';


Future<void> configureDependencies() async {
  GetIt.I.registerLazySingleton(() => Dio());
  GetIt.I.registerLazySingleton(() => FlutterSecureStorage());
  GetIt.I.registerLazySingleton(() => LoginRepository(dio: GetIt.I<Dio>(), flutterSecureStorage: GetIt.I<FlutterSecureStorage>()));
  GetIt.I.registerLazySingleton(() => OAuthRepositories(dio: GetIt.I<Dio>()));
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      WaterDrinkSchema,
      UserProfileSchema,
    ],
    directory: dir.path,
  );
  GetIt.I.registerLazySingleton(() => isar);
  GetIt.I.registerLazySingleton(() => WaterTrackerRepository(isar: GetIt.I<Isar>()));
  GetIt.I.registerLazySingleton(() => UserProfileRepository(isar: GetIt.I<Isar>(), dio: GetIt.I<Dio>(), flutterSecureStorage: GetIt.I<FlutterSecureStorage>()));

  GetIt.I.registerFactory<AuthBloc>(
    () => AuthBloc(
      oauthRepositories: GetIt.I<OAuthRepositories>(),
      loginRepository: GetIt.I<LoginRepository>(),
      userProfileRepository: GetIt.I<UserProfileRepository>(),
      flutterSecureStorage: GetIt.I<FlutterSecureStorage>(),
    ),
  );

  GetIt.I.registerFactory<HealthWidgetsBloc>(
    () => HealthWidgetsBloc(
      waterTrackerRepository: GetIt.I<WaterTrackerRepository>(), 
      userProfileRepository: GetIt.I<UserProfileRepository>(),
    )..add(HealthWidgetsReadEvent()),
  );

  GetIt.I.registerFactory<ProfileWidgetsBloc>(
  () => ProfileWidgetsBloc(
    userProfileRepository: GetIt.I<UserProfileRepository>(),
  )..add(ProfileWidgetsReadEvent()),
);

}
