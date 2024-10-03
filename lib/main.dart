import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songer/providers/song_provider.dart';
import 'screens/home_screen.dart'; // Import HomeScreen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SongProvider>(create: (_) => SongProvider()),
      ],
      child: const SongerApp(),
    ),
  );
}

class SongerApp extends StatelessWidget {
  const SongerApp({super.key});

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
