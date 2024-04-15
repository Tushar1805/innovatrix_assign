import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innovatrix_assign/UI/home_screen.dart';
import 'package:innovatrix_assign/UI/login.dart';
import 'package:innovatrix_assign/models/auth_service.dart';
import 'package:innovatrix_assign/models/user_database.dart';

void main() async {
  // Initialize users Isar database
  WidgetsFlutterBinding.ensureInitialized();
  await UserDatabase.initialize();
  final isLoggedIn = await AuthService().isLoggedIn();
  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
