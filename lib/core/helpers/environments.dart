import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  Environments._();

  static String? param(String paramName) => dotenv.env[paramName];

  static Future<void> loadEnvs() => dotenv.load();
}
