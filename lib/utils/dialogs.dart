import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:songer/models/song_model.dart';
import 'package:songer/providers/song_provider.dart';
import 'package:provider/provider.dart';

Future<void> showAddSongDialog(BuildContext context) async {
  final songProvider = Provider.of<SongProvider>(context, listen: false);
  String? songPath;
  String songTitle = '';
  String artistName = '';
  List<String> tags = [];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Song'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                songTitle = value;
              },
              decoration: InputDecoration(labelText: 'Song Title'),
            ),
            TextField(
              onChanged: (value) {
                artistName = value;
              },
              decoration: InputDecoration(labelText: 'Artist Name'),
            ),
            TextField(
              onChanged: (value) {
                tags = value.split(',').map((tag) => tag.trim()).toList();
              },
              decoration: InputDecoration(labelText: 'Tags (comma-separated)'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                // Use file picker to select an MP3 file
                String? selectedFilePath = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                  allowedExtensions: ['mp3'],
                ).then((result) => result?.files.single.path);
                
                if (selectedFilePath != null) {
                  songPath = selectedFilePath; // Store the selected file path
                }
              },
              child: Text('Select MP3 File'),
            ),
            if (songPath != null) Text('Selected: $songPath'), // Show selected file path
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (songPath != null && songTitle.isNotEmpty && artistName.isNotEmpty) {
                // Create a Song object and add it to the provider
                final song = Song(
                  title: songTitle,
                  artist: artistName,
                  path: songPath!, // Include path
                  tags: tags,
                );
                songProvider.addSong(song); // Update the provider
                Navigator.of(context).pop();
              }
            },
            child: Text('Add Song'),
          ),
        ],
      );
    },
  );
}
