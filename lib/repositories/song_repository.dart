// import 'package:songer/database/song_database.dart';
// import 'package:songer/models/song_model.dart';

import 'package:songer/models/song_model.dart';

class SongRepository {
  static final SongRepository instance = SongRepository._internal();
  SongRepository._internal();

  // final SongDatabase _database = SongDatabase();

  // Future<void> addSong(Song song) async {
  //   final db = await _database.database;
  //   // await db.insert('songs', song.toMap());
  // }

  // Future<List<Song>> getSongs() async {
  //   final db = await _database.database;
  //   final List<Map<String, dynamic>> maps = await db.query('songs');
  //   // return List.generate(maps.length, (i) {
  //   //   // return Song.fromMap(maps[i]);
  //   // });
  // }

  // Additional methods for playlists and tags...
  Map<String, Song> songsCollection = {};

  static List<Song> get allSongs =>
      SongRepository.instance.songsCollection.values.toList();

  static void setSongs(List<Song> songs) {
    SongRepository.instance.songsCollection = {
      for (var item in songs) item.path: item
    }; //Map.fromIterable(songs, key: (Song element) => element.path,) songs.map((e) => {e.path, e}).to
  }

  static Song? getSong(String path) {
    return SongRepository.instance.songsCollection[path];
  }
}
