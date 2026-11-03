import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}