import 'package:flutter/material.dart';
import 'addpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> podcastEpisodes = [];
  String selectedCategory = 'ทั้งหมด';

  final List<String> categories = [
    'ทั้งหมด',
    'เทคโนโลยี',
    'บันเทิง',
    'การศึกษา',
    'สุขภาพ',
    'ข่าวสาร',
    'แรงบันดาลใจ',
  ];

  void _navigateToAddPage({Map<String, dynamic>? episode, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(episode: episode),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          podcastEpisodes[index] = result;
        } else {
          podcastEpisodes.add(result);
        }
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
    List<Map<String, dynamic>> filteredEpisodes = podcastEpisodes
        .where((episode) => selectedCategory == 'ทั้งหมด' || episode['category'] == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast Episodes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 181, 181, 181)),
                dropdownColor: Colors.purple[100], // พื้นหลังดรอปดาวน์
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: filteredEpisodes.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีพอดแคสต์ในหมวดนี้',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: filteredEpisodes.length,
              itemBuilder: (context, index) {
                final episode = filteredEpisodes[index];
                return Dismissible(
                  key: Key(episode['title']),
                  onDismissed: (direction) => _deleteEpisode(index),
                  background: Container(color: Colors.red),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: const Icon(Icons.album, size: 40, color: Colors.purple),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: episode['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' (${episode['category']})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${episode['duration']} นาที  ${episode['date']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.purple,
                              size: 40,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPage(),
        backgroundColor: Colors.purple.withOpacity(0.8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
