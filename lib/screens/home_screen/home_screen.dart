import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:songer/models/song_model.dart';
import 'package:songer/repositories/song_repository.dart';
import 'package:songer/services/app_audio_player.dart';
import 'package:songer/widgets/bottom_player_bar.dart';
import 'package:songer/widgets/song_widget.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> filteredSongs = [];

  /// The line `String? _currentSong;` is declaring a variable named `_currentSong` of type `String?`.
  // String? _currentSong;
  late Directory _songsDirectory;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSongsDirectory();
  }

  Future<void> _initializeSongsDirectory() async {
    // Get the app's directory for storing songs
    final Directory appDir = await getApplicationDocumentsDirectory();
    _songsDirectory = Directory('${appDir.path}/songs');

    // Create the directory if it doesn't exist
    if (!await _songsDirectory.exists()) {
      await _songsDirectory.create(recursive: true);
    }

    // Fetch the existing songs
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    List<Song> _songs = await Song.fromSongPaths(_songsDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .where(
            (file) => file.path.endsWith('.mp3') || file.path.endsWith('.flac'))
        .map((e) => e.path)
        .toList());
    _songs.sort((Song a, Song b) => a.title.compareTo(b.title));
    SongRepository.setSongs(_songs);
    setState(() {
      filteredSongs = _songs;
    });
  }

  Future<void> _addSong() async {
    // Open file picker to select a song
    // final FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['mp3'],
    // );

    // if (result != null) {
    //   final File selectedFile = File(result.files.single.path!);
    //   final File newFile =
    //       File('${_songsDirectory.path}/${selectedFile.uri.pathSegments.last}');

    //   // Copy the selected song to the app's directory
    //   await selectedFile.copy(newFile.path);
    //   await _fetchSongs(); // Refresh the song list
    // }
  }

  // void _playSong(String songName) {
  //   setState(() {
  //     _currentSong = songName; // Set the current song name
  //   });
  //   _audioPlayer.play(song.path);
  // }

  // void _pauseSong() {
  //   _audioPlayer.pause();
  // }

  // void _resumeSong() {
  //   _audioPlayer.resume();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: Colors.blue,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredSongs = SongRepository.allSongs
                              .where((item) => item.path
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: filteredSongs.isEmpty
          ? const Center(child: Text("No songs available. Add some!"))
          : ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final Song song = filteredSongs[index];
                // String songName = song.path.split('\\').last;
                return SongWidget(
                  song:
                      song, //song.path.split('/').last song.path.split('/').last.replaceAll('.mp3', ''),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSong,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: const BottomSongPlayer(),
    );
  }
}
