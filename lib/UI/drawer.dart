import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innovatrix_assign/UI/login.dart';
import 'package:innovatrix_assign/UI/profile_page.dart';
import 'package:innovatrix_assign/models/auth_service.dart';
import 'package:innovatrix_assign/models/user_database.dart';

class CustomDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).currentUser;
    return Drawer(
      child: Container(
        color: Colors.deepPurple.shade200,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  user == null ? Text("John Doe") : Text(user.name.toString()),
              accountEmail: user == null
                  ? Text("john@gmail.com")
                  : Text(user.email.toString()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/profile_pic.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Handle profile tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                ); // Close the drawer
                // Add your profile navigation logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Handle logout tap
                AuthService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
                // Add your logout logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
