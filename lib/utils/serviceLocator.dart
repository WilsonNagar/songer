import 'dart:async';
import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:songer/providers/song_provider.dart';
import 'package:songer/repositories/song_repository.dart';
import 'package:songer/services/app_audio_player.dart';
import 'package:songer/utils/navigation_service.dart';
import 'package:songer/utils/routemanager.dart';

GetIt locator = GetIt.I;
Completer<void> locatorReady = Completer();

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => RouteManager());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SongController());
  AppAudioPlayer.instance.audioPlayer.play();
  AppAudioPlayer.instance.audioPlayer.stop();
}
