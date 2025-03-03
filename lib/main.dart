import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const PodcastApp());
}

class PodcastApp extends StatelessWidget {
  const PodcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podcast Episodes',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}
