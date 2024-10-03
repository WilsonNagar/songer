class Song {
  final String title;
  final String artist;
  final String path; // Path to the MP3 file
  final List<String> tags;

  Song({
    required this.title,
    required this.artist,
    required this.path,
    required this.tags,
  });

  // Convert a Song object into a Map object for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'path': path,
      'tags': tags.join(','), // Convert list of tags to a comma-separated string
    };
  }

  // Convert a Map object into a Song object
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'],
      artist: map['artist'],
      path: map['path'],
      tags: (map['tags'] as String).split(','), // Split the comma-separated string back into a list
    );
  }
}
