import 'package:audiotags/audiotags.dart';

class Song {
  final String path;
  final Tag? tag;

  Song({
    required this.path,
    this.tag,
  });

  /// Factory constructor to create a Song object from a file path and its metadata tag.
  static Future<Song> fromPath(String path) async {
    // try {
    // Fetch the tag using AudioTags
    final Tag? tag = await AudioTags.read(path);

    // if (tag != null) {
    return Song(path: path, tag: tag);
    //   } else {
    //     print("No metadata found for file: $path");
    //     return Song(
    //       path: path,
    //     ); // Return null if the tag is not available
    //   }
    // } catch (e) {
    //   print("Error reading tags for file $path: $e");
    //   return Song(
    //     path: path,
    //   );
    // }
  }

  String get title => tag?.title ?? path.split('\\').last;
  String get artist => tag?.trackArtist ?? tag?.albumArtist ?? "Unknown Artist";

  static Future<List<Song>> fromSongPaths(List<String> paths) async {
    List<Song> songs = [];
    for (String e in paths) {
      songs.add(await fromPath(e));
    }
    return songs;
  }
}
