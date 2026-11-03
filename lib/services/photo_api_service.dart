import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_model.dart';

class PhotoApiService {
  final String baseUrl = 'https://picsum.photos/v2';

  Future<List<PhotoModel>> fetchPhotos({int page = 1, int limit = 20}) async {
    final response = await http.get(Uri.parse('$baseUrl/list?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil referensi gambar');
    }
  }
}