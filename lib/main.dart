import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import HomeScreen

void main() {
  runApp(SongerApp());
}

class SongerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Use HomeScreen here
    );
  }
}
