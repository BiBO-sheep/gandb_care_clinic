import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../api_config.dart';
import 'unauthorized_exception.dart';

class ApiService {
  final String _baseUrl = ApiConfig.baseUrl;
  final _storage = const FlutterSecureStorage();
  
  // Timeout settings
  static const int _timeoutSeconds = 15;

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse('$_baseUrl/$endpoint'), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));
      return _processResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Koneksi ke server terputus (Timeout)');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: _timeoutSeconds));
      return _processResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Koneksi ke server terputus (Timeout)');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .put(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: _timeoutSeconds));
      return _processResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Koneksi ke server terputus (Timeout)');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  http.Response _processResponse(http.Response response) {
    // If the token is invalid or expired, the backend usually returns 401.
    // In a full implementation, we might clear the token and redirect to login here.
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 422) {
      // Validation error
      return response; // Let the controller handle validation parsing
    } else if (response.statusCode == 404) {
      throw Exception('Data tidak ditemukan (404).');
    } else if (response.statusCode >= 500) {
      throw Exception('Terjadi kesalahan pada server (500).');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
