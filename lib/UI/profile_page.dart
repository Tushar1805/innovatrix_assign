import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innovatrix_assign/models/user_database.dart';

// ignore: must_be_immutable
class ProfilePage extends ConsumerWidget {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).currentUser;
    _nameController = TextEditingController(text: user!.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Add logic to change profile picture
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile_pic.jpg'),
                    // Change the image as per your requirement
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(userProvider).updateUser(
                            id: user.userId,
                            name: _nameController!.text,
                            email: _emailController!.text,
                            phone: _phoneController!.text,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Profile Updated Successfully"),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content:
                              Text("Error Updating Profile: ${e.toString()}"),
                        ),
                      );
                    }
                  },
                  child: Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
