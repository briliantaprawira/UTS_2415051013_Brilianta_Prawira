import 'package:flutter/material.dart';

void main() {
  runApp(const ArtSpireApp());
}

class ArtSpireApp extends StatelessWidget {
  const ArtSpireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtSpire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('ArtSpire')),
        body: const Center(
          child: Text('Selamat Datang di ArtSpire!'),
        ),
      ),
    );
  }
}