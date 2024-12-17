import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songer/models/song_model.dart';
import 'package:songer/providers/song_provider.dart';
import 'package:songer/utils/serviceLocator.dart';

class SongWidget extends StatelessWidget {
  final Song song;

  const SongWidget({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.music_note, color: Colors.white),
      ),
      title: Text(
        song.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Consumer2<SongPlayingProvider, CurrentSongProvider>(
        builder: (context, SongPlayingProvider isSongPlaying,
            CurrentSongProvider currentSongProvider, child) {
          return IconButton(
            icon: Icon(
              (isSongPlaying.value && (currentSongProvider.value == song.path))
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.blue,
            ),
            onPressed: () {
              locator.get<SongController>().play(song.path);
            },
          );
        },
      ),
    );
  }
}
