import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://172.20.2.22:8000/api';
  }
}
