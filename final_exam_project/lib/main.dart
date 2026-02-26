import 'package:flutter/material.dart';

void main() => runApp(const MusicApp());

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});         

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Music App')),
        body: const Center(child: Text('Welcome')),
      ),
    );
  }
}
