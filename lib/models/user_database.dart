import 'package:innovatrix_assign/models/users.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class UserDatabase {
  static late Isar isar;
  // Initialize

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [UsersSchema],
      directory: dir.path,
    );
  }

  // List of users
  List<Users> listOfUsers = [];

  // CREATE
  Future<void> addUser(
      {required String name,
      required String email,
      required String phone}) async {
    Users? newUser;
    newUser!.name = name;
    newUser.email = email;
    newUser.phone = phone;

    await isar.writeTxn(() => isar.users.put(newUser));
    await fetchUser();
  }

  // READ

  Future<void> fetchUser() async {
    List<Users> fetchedUsers = await isar.users.where().findAll();
    listOfUsers.clear();
    listOfUsers.addAll(fetchedUsers);
  }

  // UPDATE
  Future<void> updateUser(
      {required Id id, String? name, String? email, String? phone}) async {
    final exitingUser = await isar.users.get(id);

    if (exitingUser != null) {
      exitingUser.name = name!;
      exitingUser.email = email!;
      exitingUser.phone = phone!;

      await isar.writeTxn(() => isar.users.put(exitingUser));
      await fetchUser();
    }
  }

  // DELETE

  Future<void> deleteUser({required Id id}) async {
    await isar.writeTxn(() => isar.users.delete(id));
    await fetchUser();
  }
}
