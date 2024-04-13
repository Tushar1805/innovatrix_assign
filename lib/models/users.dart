import 'package:isar/isar.dart';

part 'users.g.dart';

@Collection()
class Users {
  Id userId = Isar.autoIncrement;

  @Index(caseSensitive: true)
  late String name;

  @Index(unique: true)
  late String email;
  late String phone;

  late String password;
}

class AuthService {}
