import 'package:flutter/material.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> podcastEpisodes = [];

  void _navigateToAddPage() async {
    final newEpisode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );

    if (newEpisode != null) {
      setState(() {
        podcastEpisodes.add(newEpisode);
      });
    }
  }

  void _deleteEpisode(int index) {
    setState(() {
      podcastEpisodes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podcast Episodes')),
      body: podcastEpisodes.isEmpty
          ? const Center(child: Text('No podcast episodes added.'))
          : ListView.builder(
              itemCount: podcastEpisodes.length,
              itemBuilder: (context, index) {
                final episode = podcastEpisodes[index];
                return Dismissible(
                  key: Key(episode['title']),
                  onDismissed: (direction) => _deleteEpisode(index),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(episode['title']),
                    subtitle: Text(
                        '${episode['duration']} min • ${episode['date']}'),
                    trailing: Text(episode['category']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
