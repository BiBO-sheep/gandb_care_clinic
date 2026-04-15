import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Ganti dengan URL Laravel kamu (misal: http://10.0.2.2:8000/api untuk emulator Android)
  static const String baseUrl = 'https://api.domain-laravel-kamu.com/api';

  // Contoh template request POST
  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
