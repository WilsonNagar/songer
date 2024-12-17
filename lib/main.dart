import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:songer/providers/song_provider.dart';
import 'package:songer/utils/navigation_service.dart';
import 'package:songer/utils/serviceLocator.dart';
import 'screens/home_screen/home_screen.dart'; // Import HomeScreen

void main() async {
  runZonedGuarded(() async {
    await WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    SongController songProvider = locator.get<SongController>();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<VolumeProvider>(
              create: (_) => songProvider.volumeProvider),
          ChangeNotifierProvider<SpeedProvider>(
              create: (_) => songProvider.speedProvider),
          ChangeNotifierProvider<DurationProvider>(
              create: (_) => songProvider.durationProvider),
          ChangeNotifierProvider<PositionProvider>(
              create: (_) => songProvider.positionProvider),
          ChangeNotifierProvider<CurrentSongProvider>(
              create: (_) => songProvider.currentSong),
          ChangeNotifierProvider<LoopModeProvider>(
              create: (_) => songProvider.loopMode),
          ChangeNotifierProvider<SongPlayingProvider>(
              create: (_) => songProvider.isSongPlaying),
        ],
        child: KeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.space) {
              // songProvider.pla
            }
          },
          child: const SongerApp(),
        ),
      ),
    );
  }, (_, __) {});
}

class SongerApp extends StatelessWidget {
  const SongerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator.get<NavigationService>().navigationKey,
      title: 'Songer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Use HomeScreen here
    );
  }
}
