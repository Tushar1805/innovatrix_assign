import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        color: Colors.grey.shade100,
        child: Text("Logout"),
      ),
      appBar: AppBar(
        title: Text("GraphQL Data"),
      ),
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
