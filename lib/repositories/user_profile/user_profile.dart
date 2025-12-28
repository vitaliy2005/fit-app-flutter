import 'package:isar_community/isar.dart';

part 'user_profile.g.dart';

@Collection()
class UserProfile {
  Id id = 0;

  late String surname;
  late String name;
  late String email;
}