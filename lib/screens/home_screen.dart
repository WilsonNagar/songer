import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songer'),
      ),
      body: Center(
        child: Text(
          'Welcome to Songer!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add a song or navigate to tagging
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
