import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    // Matikan .env sementara agar langsung fokus ke hosting
    return 'https://gnb-care-clinic.bngshot.my.id/api';
  }
}

