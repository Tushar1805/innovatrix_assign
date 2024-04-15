import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innovatrix_assign/models/auth_service.dart';
import 'package:innovatrix_assign/models/users.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bcrypt/bcrypt.dart';

final userProvider =
    ChangeNotifierProvider<UserDatabase>((ref) => UserDatabase());

class UserDatabase extends ChangeNotifier {
  static late Isar isar;

  //A bool variable for show and hide password
  bool isVisible = false;
  void changeVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  bool isConfirmVisible = false;
  void changeConfirmVisibility() {
    isConfirmVisible = !isConfirmVisible;
    notifyListeners();
  }

  //Here is our bool variable
  bool isLoginTrue = false;
  String regMsg = "";
  String errMsg = "";

  // Initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    print("Path: ${dir.path.toString()}");
    isar = await Isar.open(
      [UsersSchema],
      directory: dir.path,
    );
  }

  // List of users
  List<Users> listOfUsers = [];
  Users? currentUser;

  // CREATE
  Future<void> signUp(
      {required String name,
      required String email,
      required String password,
      required String phone}) async {
    final existingUsers =
        await isar.users.where().emailEqualTo(email).findAll();

    if (existingUsers.isEmpty) {
      final hashedPassword = hashPassword(password);
      final newUser = Users()
        ..name = name
        ..password = hashedPassword
        ..email = email
        ..phone = phone;

      await isar.writeTxn(() => isar.users.put(newUser));
      regMsg = "User Registered Successfully";
      notifyListeners();
      await fetchUser();
    } else {
      regMsg = "Username already exists";
      throw Exception(regMsg);
    }
    notifyListeners();
  }

  // Get Current User

  Future<void> getCurrentUser(String id) async {
    final data =
        await isar.users.where().userIdEqualTo(int.parse(id)).findFirst();
    print("User ID: $id");
    if (data.toString() != "null") {
      currentUser = data;
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String username, String password) async {
    final data = await isar.users.where().emailEqualTo(username).findFirst();
    if (data.toString() != "null") {
      isLoginTrue = verifyPassword(password, data!.password);
      if (isLoginTrue) {
        currentUser = data;
        print("***********");
        await AuthService().setSessionToken(data.userId.toString());
        notifyListeners();
      } else {
        errMsg = "Incorrect Password";
        notifyListeners();
      }
      return isLoginTrue;
    } else {
      errMsg = "No user found with the provided email";
      notifyListeners();
      return false;
    }
  }

  bool verifyPassword(String password, String hashedPassword) {
    return comparePassword(password, hashedPassword);
  }

  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool comparePassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  // READ
  Future<void> fetchUser() async {
    List<Users> fetchedUsers = await isar.users.where().findAll();
    listOfUsers.clear();
    listOfUsers.addAll(fetchedUsers);
    notifyListeners();
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
      currentUser =
          await isar.users.where().userIdEqualTo(id.toInt()).findFirst();
      await fetchUser();
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteUser({required Id id}) async {
    await isar.writeTxn(() => isar.users.delete(id));
    await fetchUser();
    notifyListeners();
  }
}
