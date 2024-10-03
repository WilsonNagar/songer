import 'package:songer/database/song_database.dart';
import 'package:songer/models/song_model.dart';

class SongRepository {
  final SongDatabase _database = SongDatabase();

  Future<void> addSong(Song song) async {
    final db = await _database.database;
    await db.insert('songs', song.toMap());
  }

  Future<List<Song>> getSongs() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query('songs');
    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  // Additional methods for playlists and tags...
}
