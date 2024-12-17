// import 'package:audiotags/audiotags.dart';
// import 'package:file_selector/file_selector.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:songer/models/song_model.dart';
// import 'package:songer/providers/song_provider.dart';

// Future<void> showAddSongDialog(BuildContext context) async {
//   final songProvider = Provider.of<SongProvider>(context, listen: false);
//   String songTitle = '';
//   String artistName = '';
//   List<String> tags = [];
//   String? songPath;

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _artistController = TextEditingController();
//   final TextEditingController _tagController = TextEditingController();

//   String cleanString(String input) {
//     // Remove all numbers and file extensions
//     String result = input.replaceAll(
//         RegExp(r'\d+|\.pdf|\.docx|\.txt|\.jpg|\.png|\.mp3|\.mp4'), '');

//     // Trim leading and trailing spaces
//     result = result.trim();

//     return result;
//   }

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Add Song'),
//         content: StatefulBuilder(
//           builder: (context, setState) {
//             return SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Button to select MP3 file
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Open file picker
//                       final XFile? file = await openFile(
//                         acceptedTypeGroups: [
//                           XTypeGroup(label: 'audio', extensions: ['mp3']),
//                         ],
//                       );
//                       if (file != null) {
//                         Tag? tag = await AudioTags.read(file.path);
//                         setState(() {
//                           _titleController.text = tag?.title ?? cleanString(file.name);
//                           _artistController.text = tag?.trackArtist ?? "";
//                           songPath = file.path; // Update song path with selected file
//                         //   _titleController.text = songTitle; // Update title input
//                         });
//                       }
//                     },
//                     child: Text('Select MP3 File'),
//                   ),
//                   SizedBox(height: 10),
//                   // Song Title Input
//                   TextField(
//                     controller: _titleController, // Controller for song title
//                     decoration: InputDecoration(labelText: 'Song Title'),
//                     onChanged: (value) {
//                       songTitle = value;
//                     },
//                   ),
//                   // Artist Name Input
//                   TextField(
//                     controller: _artistController, // Controller for artist name
//                     decoration: InputDecoration(labelText: 'Artist Name'),
//                     onChanged: (value) {
//                       artistName = value;
//                     },
//                   ),
//                   // Tags Input
//                   TextField(
//                     controller: _tagController, // Controller for tags
//                     decoration: InputDecoration(labelText: 'Tags (comma-separated)'),
//                     onChanged: (value) {
//                       tags = value.split(',').map((tag) => tag.trim()).toList();
//                     },
//                   ),
//                   if (songPath != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text('Selected: $songPath'), // Show selected file path
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (songPath != null && songTitle.isNotEmpty && artistName.isNotEmpty) {
//                 // Create a Song object and add it to the provider
//                 final song = Song(
//                   title: songTitle,
//                   artist: artistName,
//                   path: songPath!, // Include path
//                   tags: tags,
//                 );
//                 songProvider.addSong(song); // Update the provider
//                 Navigator.of(context).pop();
//               } else {
//                 // Show an error message if validation fails
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Please fill in all fields and select a file.')),
//                 );
//               }
//             },
//             child: Text('Add Song'),
//           ),
//         ],
//       );
//     },
//   );
// }
