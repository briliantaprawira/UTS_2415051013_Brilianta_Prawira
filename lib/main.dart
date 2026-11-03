import 'package:flutter/material.dart';
import 'services/photo_api_service.dart';
import 'models/photo_model.dart';

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
      home: const GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final PhotoApiService _apiService = PhotoApiService();
  late Future<List<PhotoModel>> _futurePhotos;

  @override
  void initState() {
    super.initState();
    _futurePhotos = _apiService.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive: Menentukan jumlah kolom berdasarkan lebar layar
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Default HP
    if (screenWidth > 600) crossAxisCount = 3; // Tablet
    if (screenWidth > 900) crossAxisCount = 4; // Desktop/Web

    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtSpire Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _futurePhotos = _apiService.fetchPhotos(page: DateTime.now().second % 10 + 1); // Refresh dengan halaman acak
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<PhotoModel>>(
        future: _futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada gambar ditemukan.'));
          }

          final photos = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8, // Mengatur agar gambar sedikit vertikal (potret)
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      photo.downloadUrl,
                      fit: BoxFit.cover,
                      // Indikator loading saat gambar sedang diunduh
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                    // Gradient dan nama author di bagian bawah gambar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                        child: Text(
                          photo.author,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}