import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songer/utils/dialogs.dart';
import '../providers/song_provider.dart'; // Adjust the import as necessary

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final songProvider =
        Provider.of<SongProvider>(context); // Access the provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Songer'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigate to search
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome to Songer!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: songProvider.loadSongs(), // Load songs
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: songProvider.songs.length,
                      itemBuilder: (context, index) {
                        final song = songProvider.songs[index];
                        return Card(
                          child: ListTile(
                            title: Text(song.title),
                            subtitle: Text(song.artist),
                            trailing: Wrap(
                              children: song.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                            ),
                            onTap: () {
                              // Navigate to player screen or song details
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSongDialog(context); // Call the dialog function here
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play), label: 'Playlists'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Tags'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
