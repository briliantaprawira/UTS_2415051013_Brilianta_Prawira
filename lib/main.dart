import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/main_screen.dart';
import 'services/project_supabase_service.dart';
import 'repositories/project_repository.dart';
import 'providers/project_provider.dart';

void main() async {
  // Wajib untuk inisialisasi sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase menggunakan kredensial proyekmu
  await Supabase.initialize(
    url: 'https://xiydbqmtupnoriwoegiw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpeWRicW10dXBub3Jpd29lZ2l3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMDUyODIsImV4cCI6MjEwODY4MTI4Mn0.2PwidUFGlwmMoZLSSE_ffqrDx_I1i43wL6P0L0h0wDs',
  );

  // Siapkan repository
  final repository = ProjectRepository(ProjectSupabaseService());

  runApp(
    // Daftarkan Provider di level tertinggi aplikasi
    ChangeNotifierProvider(
      create: (context) => ProjectProvider(repository)..loadProjects(),
      child: const ArtSpireApp(),
    ),
  );
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