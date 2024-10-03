import 'package:flutter/material.dart';
import '../repositories/song_repository.dart';
import '../models/song_model.dart';

class SongProvider with ChangeNotifier {
  final SongRepository _songRepository = SongRepository();
  List<Song> _songs = [];

  List<Song> get songs => _songs;

  Future<void> loadSongs() async {
    _songs = await _songRepository.getSongs(); // Fetch songs from the repository
    notifyListeners(); // Notify listeners to rebuild UI
  }

  Future<void> addSong(Song song) async {
    await _songRepository.addSong(song); // Add song through the repository
    await loadSongs(); // Reload songs to update the UI
  }
}
