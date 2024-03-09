import 'package:flutter/widgets.dart';
import 'package:parking_app/core/helpers/environments.dart';

class ApplicationStartConfig {
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _loadEnvs();
  }

  Future<void> _loadEnvs() async => Environments.loadEnvs();
}
